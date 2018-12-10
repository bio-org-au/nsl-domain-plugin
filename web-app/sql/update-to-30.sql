update tree_element ute
set synonyms = synonyms_as_jsonb(ute.instance_id, 'id.biodiversity.org.au'),
    synonyms_html = coalesce(synonyms_as_html(ute.instance_id), '<synonyms></synonyms>')
where ute.id in (select distinct(te.id)
                 from tree_element te
                        join tree_version_element tve on te.id = tve.tree_element_id
                        join tree t on (t.current_tree_version_id = tve.tree_version_id) OR
                                       (t.default_draft_tree_version_id = tve.tree_version_id)
                 where te.synonyms <> synonyms_as_jsonb(te.instance_id, 'id.biodiversity.org.au'));

-- version
UPDATE db_version
SET version = 30
WHERE id = 1;
