DROP MATERIALIZED VIEW IF EXISTS taxon_view;

-- taxon-view uses this function
DROP FUNCTION IF EXISTS find_tree_rank(TEXT, INT);
-- this function is a little slow, but it works for now.
CREATE FUNCTION find_tree_rank(tve_id TEXT, rank_sort_order INT)
  RETURNS TABLE
          (
            name_element TEXT,
            rank         TEXT,
            sort_order   INT
          )
  LANGUAGE SQL
AS
$$
WITH RECURSIVE walk (parent_id, name_element, rank, sort_order) AS (
  SELECT tve.parent_id,
         n.name_element,
         r.name,
         r.sort_order
  FROM tree_version_element tve
         JOIN tree_element te ON tve.tree_element_id = te.id
         JOIN name n ON te.name_id = n.id
         JOIN name_rank r ON n.name_rank_id = r.id
  WHERE tve.element_link = tve_id
    AND r.sort_order >= rank_sort_order
  UNION ALL
  SELECT tve.parent_id,
         n.name_element,
         r.name,
         r.sort_order
  FROM walk w,
       tree_version_element tve
         JOIN tree_element te ON tve.tree_element_id = te.id
         JOIN name n ON te.name_id = n.id
         JOIN name_rank r ON n.name_rank_id = r.id
  WHERE tve.element_link = w.parent_id
    AND r.sort_order >= rank_sort_order
)
SELECT w.name_element,
       w.rank,
       w.sort_order
FROM walk w
WHERE w.sort_order = rank_sort_order
limit 1
$$;

CREATE MATERIALIZED VIEW taxon_view AS

  -- synonyms bit
  (SELECT tree.host_name || '/' || (syn ->> 'concept_link')                                               AS "taxonID",
          acc_nt.name                                                                                     AS "nameType",
          tree.host_name || tve.element_link                                                              AS "acceptedNameUsageID",
          acc_name.full_name                                                                              AS "acceptedNameUsage",
          CASE
            WHEN acc_ns.name NOT IN ('legitimate', '[default]')
              THEN acc_ns.name
            ELSE NULL END                                                                                 AS "nomenclaturalStatus",
          syn ->> 'type'                                                                                  AS "taxonomicStatus",
          (syn ->> 'type' ~ 'parte')                                                                      AS "proParte",
          syn_name.full_name                                                                              AS "scientificName",
          tree.host_name || '/' || (syn ->> 'name_link')                                                  AS "scientificNameID",
          syn_name.simple_name                                                                            AS "canonicalName",
          CASE
            WHEN syn_nt.autonym
              THEN NULL
            ELSE regexp_replace(substring(syn_name.full_name_html FROM '<authors>(.*)</authors>'), '<[^>]*>', '', 'g')
            END                                                                                           AS "scientificNameAuthorship",
          -- only in accepted names
          NULL                                                                                            AS "parentNameUsageID",
          syn_rank.name                                                                                   AS "taxonRank",
          syn_rank.sort_order                                                                             AS "taxonRankSortOrder",
          (SELECT name_element FROM find_tree_rank(tve.element_link, 10) ORDER BY sort_order ASC LIMIT 1) AS "kindom",
          -- the below works but is a little slow
          -- find another efficient way to do it.
          (SELECT name_element FROM find_tree_rank(tve.element_link, 30) ORDER BY sort_order ASC LIMIT 1) AS "class",
          (SELECT name_element FROM find_tree_rank(tve.element_link, 40) ORDER BY sort_order ASC LIMIT 1) AS "subclass",
          (SELECT name_element FROM find_tree_rank(tve.element_link, 80) ORDER BY sort_order ASC LIMIT 1) AS "family",
          syn_name.created_at                                                                             AS "created",
          syn_name.updated_at                                                                             AS "modified",
          tree.name                                                                                       AS "datasetName",
          tree.host_name || '/' || (syn ->> 'concept_link')                                               AS "taxonConceptID",
          (syn ->> 'cites')                                                                               AS "nameAccordingTo",
          tree.host_name || (syn ->> 'cites_link')                                                        AS "nameAccordingToID",
          profile -> 'APC Comment' ->> 'value'                                                            AS "taxonRemarks",
          profile -> 'APC Dist.' ->> 'value'                                                              AS "taxonDistribution",
          -- todo check this is ok for synonyms
          regexp_replace(tve.name_path, '/', '|', 'g')                                                    AS "higherClassification",
          CASE
            WHEN firstHybridParent.id IS NOT NULL
              THEN firstHybridParent.full_name
            ELSE NULL END                                                                                 AS "firstHybridParentName",
          CASE
            WHEN firstHybridParent.id IS NOT NULL
              THEN tree.host_name || '/' || firstHybridParent.uri
            ELSE NULL END                                                                                 AS "firstHybridParentNameID",
          CASE
            WHEN secondHybridParent.id IS NOT NULL
              THEN secondHybridParent.full_name
            ELSE NULL END                                                                                 AS "secondHybridParentName",
          CASE
            WHEN secondHybridParent.id IS NOT NULL
              THEN tree.host_name || '/' || secondHybridParent.uri
            ELSE NULL END                                                                                 AS "secondHybridParentNameID",
          -- boiler plate stuff at the end of the record
          (select coalesce((SELECT value FROM shard_config WHERE name = 'nomenclatural code'),
                           'ICN')) :: TEXT                                                                AS "nomenclaturalCode",
          'http://creativecommons.org/licenses/by/3.0/' :: TEXT                                           AS "license",
          syn ->> 'instance_link'                                                                         AS "ccAttributionIRI "
   FROM tree_version_element tve
          JOIN tree ON tve.tree_version_id = tree.current_tree_version_id AND tree.accepted_tree = TRUE
          JOIN tree_element te ON tve.tree_element_id = te.id
          JOIN instance acc_inst ON te.instance_id = acc_inst.id
          JOIN instance_type acc_it ON acc_inst.instance_type_id = acc_it.id
          JOIN reference acc_ref ON acc_inst.reference_id = acc_ref.id
          JOIN NAME acc_name ON te.name_id = acc_name.id
          JOIN name_type acc_nt ON acc_name.name_type_id = acc_nt.id
          JOIN name_status acc_ns ON acc_name.name_status_id = acc_ns.id,
        jsonb_array_elements(synonyms -> 'list') syn
          JOIN NAME syn_name ON syn_name.id = (syn ->> 'name_id') :: NUMERIC :: BIGINT
          JOIN name_rank syn_rank ON syn_name.name_rank_id = syn_rank.id
          JOIN name_type syn_nt ON syn_name.name_type_id = syn_nt.id
          LEFT OUTER JOIN NAME firstHybridParent ON syn_name.parent_id = firstHybridParent.id AND syn_nt.hybrid
          LEFT OUTER JOIN NAME secondHybridParent
                          ON syn_name.second_parent_id = secondHybridParent.id AND syn_nt.hybrid
   UNION
   -- The accepted names bit
   SELECT tree.host_name || tve.element_link                                                              AS "taxonID",
          acc_nt.name                                                                                     AS "nameType",
          tree.host_name || tve.element_link                                                              AS "acceptedNameUsageID",
          acc_name.full_name                                                                              AS "acceptedNameUsage",
          CASE
            WHEN acc_ns.name NOT IN ('legitimate', '[default]')
              THEN acc_ns.name
            ELSE NULL END                                                                                 AS "nomenclaturalStatus",
          CASE
            WHEN te.excluded
              THEN 'excluded'
            ELSE 'accepted'
            END                                                                                           AS "taxonomicStatus",
          FALSE                                                                                           AS "proParte",
          acc_name.full_name                                                                              AS "scientificName",
          te.name_link                                                                                    AS "scientificNameID",
          acc_name.simple_name                                                                            AS "canonicalName",
          CASE
            WHEN acc_nt.autonym
              THEN NULL
            ELSE regexp_replace(substring(acc_name.full_name_html FROM '<authors>(.*)</authors>'), '<[^>]*>', '', 'g')
            END                                                                                           AS "scientificNameAuthorship",
          tree.host_name || tve.parent_id                                                                 AS "parentNameUsageID",
          te.rank                                                                                         AS "taxonRank",
          acc_rank.sort_order                                                                             AS "taxonRankSortOrder",
          (SELECT name_element FROM find_tree_rank(tve.element_link, 10) ORDER BY sort_order ASC LIMIT 1) AS "kindom",
          -- the below works but is a little slow
          -- find another efficient way to do it.
          (SELECT name_element FROM find_tree_rank(tve.element_link, 30) ORDER BY sort_order ASC LIMIT 1) AS "class",
          (SELECT name_element FROM find_tree_rank(tve.element_link, 40) ORDER BY sort_order ASC LIMIT 1) AS "subclass",
          (SELECT name_element FROM find_tree_rank(tve.element_link, 80) ORDER BY sort_order ASC LIMIT 1) AS "family",
          acc_name.created_at                                                                             AS "created",
          acc_name.updated_at                                                                             AS "modified",
          tree.name                                                                                       AS "datasetName",
          te.instance_link                                                                                AS "taxonConceptID",
          acc_ref.citation                                                                                AS "nameAccordingTo",
          tree.host_name || '/reference/${namespace}/' || acc_ref.id                                      AS "nameAccordingToID",
          profile -> 'APC Comment' ->> 'value'                                                            AS "taxonRemarks",
          profile -> 'APC Dist.' ->> 'value'                                                              AS "taxonDistribution",
          -- todo check this is ok for synonyms
          regexp_replace(tve.name_path, '/', '|', 'g')                                                    AS "higherClassification",
          CASE
            WHEN firstHybridParent.id IS NOT NULL
              THEN firstHybridParent.full_name
            ELSE NULL END                                                                                 AS "firstHybridParentName",
          CASE
            WHEN firstHybridParent.id IS NOT NULL
              THEN tree.host_name || '/' || firstHybridParent.uri
            ELSE NULL END                                                                                 AS "firstHybridParentNameID",
          CASE
            WHEN secondHybridParent.id IS NOT NULL
              THEN secondHybridParent.full_name
            ELSE NULL END                                                                                 AS "secondHybridParentName",
          CASE
            WHEN secondHybridParent.id IS NOT NULL
              THEN tree.host_name || '/' || secondHybridParent.uri
            ELSE NULL END                                                                                 AS "secondHybridParentNameID",
          -- boiler plate stuff at the end of the record
          (select coalesce((SELECT value FROM shard_config WHERE name = 'nomenclatural code'),
                           'ICN')) :: TEXT                                                                AS "nomenclaturalCode",
          'http://creativecommons.org/licenses/by/3.0/' :: TEXT                                           AS "license",
          tve.element_link                                                                                AS "ccAttributionIRI "
   FROM tree_version_element tve
          JOIN tree ON tve.tree_version_id = tree.current_tree_version_id AND tree.accepted_tree = TRUE
          JOIN tree_element te ON tve.tree_element_id = te.id
          JOIN instance acc_inst ON te.instance_id = acc_inst.id
          JOIN instance_type acc_it ON acc_inst.instance_type_id = acc_it.id
          JOIN reference acc_ref ON acc_inst.reference_id = acc_ref.id
          JOIN NAME acc_name ON te.name_id = acc_name.id
          JOIN name_type acc_nt ON acc_name.name_type_id = acc_nt.id
          JOIN name_status acc_ns ON acc_name.name_status_id = acc_ns.id
          JOIN name_rank acc_rank ON acc_name.name_rank_id = acc_rank.id
          LEFT OUTER JOIN NAME firstHybridParent ON acc_name.parent_id = firstHybridParent.id AND acc_nt.hybrid
          LEFT OUTER JOIN NAME secondHybridParent
                          ON acc_name.second_parent_id = secondHybridParent.id AND acc_nt.hybrid
   ORDER BY "higherClassification");