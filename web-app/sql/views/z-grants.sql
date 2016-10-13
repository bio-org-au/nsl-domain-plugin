-- grant to the web user as required
GRANT SELECT, INSERT, UPDATE, DELETE ON tree_arrangement TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON tree_link TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON tree_node TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON tree_uri_ns TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON name_tree_path TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON id_mapper TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON author TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON delayed_jobs TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON external_ref TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON help_topic TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON instance TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON instance_type TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON instance_note TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON instance_note_key TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON language TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON locale TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON name TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON name_category TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON name_group TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON name_part TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON name_rank TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON name_status TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON name_type TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON namespace TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON nomenclatural_event_type TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON ref_author_role TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON ref_type TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON reference TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON user_query TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON notification TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON name_tag TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON name_tag_name TO web;
GRANT SELECT, INSERT, UPDATE, DELETE ON comment TO web;
GRANT SELECT, UPDATE ON nsl_global_seq TO web;
GRANT SELECT, UPDATE ON hibernate_sequence TO web;
GRANT SELECT ON shard_config TO web;

GRANT SELECT ON accepted_name_vw TO web;
GRANT SELECT ON accepted_synonym_vw TO web;
GRANT SELECT ON name_detail_synonyms_vw TO web;
GRANT SELECT ON name_details_vw TO web;
GRANT SELECT ON name_detail_commons_vw TO web;
GRANT SELECT ON name_or_synonym_vw TO web;

GRANT SELECT ON tree_arrangement TO read_only;
GRANT SELECT ON tree_link TO read_only;
GRANT SELECT ON tree_node TO read_only;
GRANT SELECT ON tree_uri_ns TO read_only;
GRANT SELECT ON name_tree_path TO read_only;
GRANT SELECT ON id_mapper TO read_only;
GRANT SELECT ON author TO read_only;
GRANT SELECT ON delayed_jobs TO read_only;
GRANT SELECT ON external_ref TO read_only;
GRANT SELECT ON help_topic TO read_only;
GRANT SELECT ON instance TO read_only;
GRANT SELECT ON instance_type TO read_only;
GRANT SELECT ON instance_note TO read_only;
GRANT SELECT ON instance_note_key TO read_only;
GRANT SELECT ON language TO read_only;
GRANT SELECT ON locale TO read_only;
GRANT SELECT ON name TO read_only;
GRANT SELECT ON name_category TO read_only;
GRANT SELECT ON name_group TO read_only;
GRANT SELECT ON name_part TO read_only;
GRANT SELECT ON name_rank TO read_only;
GRANT SELECT ON name_status TO read_only;
GRANT SELECT ON name_type TO read_only;
GRANT SELECT ON namespace TO read_only;
GRANT SELECT ON nomenclatural_event_type TO read_only;
GRANT SELECT ON ref_author_role TO read_only;
GRANT SELECT ON ref_type TO read_only;
GRANT SELECT ON reference TO read_only;
GRANT SELECT ON user_query TO read_only;
GRANT SELECT ON notification TO read_only;
GRANT SELECT ON name_tag TO read_only;
GRANT SELECT ON name_tag_name TO read_only;
GRANT SELECT ON comment TO read_only;
GRANT SELECT ON shard_config TO read_only;

GRANT SELECT ON accepted_name_vw TO read_only;
GRANT SELECT ON accepted_synonym_vw TO read_only;
GRANT SELECT ON name_detail_synonyms_vw TO read_only;
GRANT SELECT ON name_details_vw TO read_only;
GRANT SELECT ON name_detail_commons_vw TO read_only;
GRANT SELECT ON name_or_synonym_vw TO read_only;
