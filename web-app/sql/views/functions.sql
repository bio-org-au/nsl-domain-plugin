-- NSL-752 NSL-2894
-- functions to get ordered output as needed by the APNI format
-- find the group name for a name based on the basionym
drop function if exists nom_group(bigint);
create function nom_group(nameid bigint)
  returns table(nom_name text, nom_id bigint)
language sql
as $$
select coalesce(bas_name.sort_name, primary_name.sort_name), coalesce(bas_name.id, primary_inst.name_id)
from instance primary_inst
       left join instance bas_inst
       join name bas_name on bas_inst.name_id = bas_name.id
       join instance_type bas_it on bas_inst.instance_type_id = bas_it.id and bas_it.name = 'basionym'
         on bas_inst.cited_by_id = primary_inst.id
       join instance_type primary_it on primary_inst.instance_type_id = primary_it.id and primary_it.primary_instance
       join name primary_name on primary_name.id = nameid
where primary_inst.name_id = nameid
limit 1;
$$;

-- find the name an orth var or alt name is of

drop function if exists orth_or_alt_of(bigint);
create function orth_or_alt_of(nameid bigint)
  returns bigint
language sql
as $$
select alt_of_inst.name_id
from name n
       join name_status ns on n.name_status_id = ns.id
       join instance alt_inst on n.id = alt_inst.name_id
       join instance_type alt_it
         on alt_inst.instance_type_id = alt_it.id and alt_it.name in ('orthographic variant', 'alternative name')
       join instance alt_of_inst on alt_of_inst.id = alt_inst.cited_by_id
where n.id = nameid
  and ns.name in ('orth. var.', 'nom. alt.');
$$;

-- get the synonyms of a name in flora order for apni

drop function if exists apni_ordered_synonymy(bigint);

create function apni_ordered_synonymy(instanceid bigint)
  returns TABLE(instance_id      bigint,
                instance_type    text,
                instance_type_id bigint,
                name_id          bigint,
                full_name        text,
                full_name_html   text,
                name_status      text,
                citation         text,
                citation_html    text,
                year             int,
                page             text,
                sort_name        text,
                misapplied       boolean,
                group_name       text,
                group_head       boolean,
                group_id         bigint)
language sql
as $$
select i.id,
       it.has_label     as instance_type,
       it.id            as instance_type_id,
       n.id             as name_id,
       n.full_name,
       n.full_name_html,
       ns.name          as name_status,
       r.citation,
       r.citation_html,
       r.year,
       cites.page,
       n.sort_name,
       it.misapplied,
       ng.nom_name      as group_name,
       ng.nom_id = n.id as group_head,
       ng.nom_id        as group_id
from instance i
       join instance_type it on i.instance_type_id = it.id
       join name n on i.name_id = n.id
       left outer join orth_or_alt_of(n.id) base_id on true
       left outer join nom_group(coalesce(base_id, n.id)) ng on true
       join name_status ns on n.name_status_id = ns.id
       left outer join instance cites on i.cites_id = cites.id
       left outer join reference r on cites.reference_id = r.id
where i.cited_by_id = instanceid
order by (it.sort_order < 20) desc,
         it.nomenclatural desc,
         it.taxonomic desc,
         group_name,
         group_head desc,
         n.id = base_id desc,
         r.year,
         n.sort_name,
         it.pro_parte,
         it.misapplied desc, it.doubtful, cites.page, cites.id;
$$;

-- apni ordered synonymy as a text output

drop function if exists apni_ordered_synonymy_text(bigint);
create function apni_ordered_synonymy_text(instanceid bigint)
  returns text
language sql
as $$
select string_agg('  ' ||
                  syn.instance_type ||
                  ': ' ||
                  syn.full_name ||
                  (case
                     when syn.name_status = 'legitimate' then ''
                     else ' ' || syn.name_status end) ||
                  (case
                     when syn.misapplied then syn.citation
                     else '' end), E'\n')
from apni_ordered_synonymy(instanceid) syn;
$$;

-- if this is a relationship instance what are we a synonym of

drop function if exists apni_synonym(bigint);
create function apni_synonym(instanceid bigint)
  returns TABLE(instance_id    bigint,
                instance_type  text,
                name_id        bigint,
                full_name      text,
                full_name_html text,
                name_status    text,
                citation       text,
                citation_html  text,
                year           int,
                page           text,
                misapplied     boolean,
                sort_name      text)
language sql
as $$
select i.id,
       it.of_label as instance_type,
       n.id        as name_id,
       n.full_name,
       n.full_name_html,
       ns.name,
       r.citation,
       r.citation_html,
       r.year,
       i.page,
       it.misapplied,
       n.sort_name
from instance i
       join instance_type it on i.instance_type_id = it.id
       join instance cites on i.cited_by_id = cites.id
       join name n on cites.name_id = n.id
       join name_status ns on n.name_status_id = ns.id
       join reference r on i.reference_id = r.id
where i.id = instanceid
  and it.relationship;
$$;

-- if this is a relationship instance what are we a synonym of as text

drop function if exists apni_synonym_text(bigint);
create function apni_synonym_text(instanceid bigint)
  returns text
language sql
as $$
select string_agg('  ' ||
                  syn.instance_type ||
                  ': ' ||
                  syn.full_name ||
                  (case
                     when syn.name_status = 'legitimate' then ''
                     else ' ' || syn.name_status end) ||
                  (case
                     when syn.misapplied
                             then 'by ' || syn.citation
                     else '' end), E'\n')
from apni_synonym(instanceid) syn;
$$;

-- apni ordered references for a name

drop function if exists apni_ordered_refrences(bigint);
create function apni_ordered_refrences(nameid bigint)
  returns TABLE(instance_id   bigint,
                instance_type text,
                citation      text,
                citation_html text,
                year          int,
                pages         text,
                page          text)
language sql
as $$
select i.id, it.name, r.citation, r.citation_html, r.year, r.pages, coalesce(i.page, citedby.page, '-')
from instance i
       join reference r on i.reference_id = r.id
       join instance_type it on i.instance_type_id = it.id
       left outer join instance citedby on i.cited_by_id = citedby.id
where i.name_id = nameid
group by r.id, i.id, it.id, citedby.id
order by r.year, it.protologue, it.primary_instance, r.citation, r.pages, i.page, r.id;
$$;

-- get the synonyms of an instance as html to store in the tree in apni synonymy order

drop function if exists synonym_as_html(bigint);
create function synonym_as_html(instanceid bigint)
  returns TABLE(html text)
language sql
as $$
SELECT CASE
         WHEN it.nomenclatural
                 THEN '<nom>' || full_name_html || ' <type>' || it.name || '</type></nom>'
         WHEN it.taxonomic
                 THEN '<tax>' || full_name_html || ' <type>' || it.name || '</type></tax>'
         WHEN it.misapplied
                 THEN '<mis>' || full_name_html || ' <type>' || it.name || '</type> by <citation>' ||
                      citation_html
                        ||
                      '</citation></mis>'
         WHEN it.synonym
                 THEN '<syn>' || full_name_html || ' <type>' || it.name || '</type></syn>'
         ELSE ''
           END
FROM apni_ordered_synonymy(instanceid)
       join instance_type it on instance_type_id = it.id
$$;

-- build JSONB representation of synonyms inside a shard
DROP FUNCTION IF EXISTS synonyms_as_jsonb( BIGINT, TEXT );
CREATE FUNCTION synonyms_as_jsonb(instance_id BIGINT, host TEXT)
  RETURNS JSONB
LANGUAGE SQL
AS $$
SELECT jsonb_build_object('list',
                          coalesce(
                            jsonb_agg(jsonb_build_object(
                                        'host', host,
                                        'instance_id', syn_inst.id,
                                        'instance_link',
                                        '/instance/apni/' || syn_inst.id,
                                        'concept_link',
                                        '/instance/apni/' || cites_inst.id,
                                        'simple_name', synonym.simple_name,
                                        'type', it.name,
                                        'name_id', synonym.id :: BIGINT,
                                        'name_link',
                                        '/name/apni/' || synonym.id,
                                        'full_name_html', synonym.full_name_html,
                                        'nom', it.nomenclatural,
                                        'tax', it.taxonomic,
                                        'mis', it.misapplied,
                                        'cites', cites_ref.citation_html,
                                        'cites_link',
                                        '/reference/apni/' || cites_ref.id,
                                        'year', cites_ref.year
                                          )), '[]' :: JSONB)
           )
FROM Instance i,
     Instance syn_inst
       JOIN instance_type it ON syn_inst.instance_type_id = it.id
       JOIN instance cites_inst ON syn_inst.cites_id = cites_inst.id
       JOIN reference cites_ref ON cites_inst.reference_id = cites_ref.id
    ,
     name synonym
WHERE i.id = instance_id
  AND syn_inst.cited_by_id = i.id
  AND synonym.id = syn_inst.name_id;
$$;