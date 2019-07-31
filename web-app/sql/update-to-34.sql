alter table if exists name_resource
    drop constraint if exists FK_r3fxh26pbju4ibi35sxxr5oyy;

alter table if exists name_resource
    drop constraint if exists FK_kfyo6ydiecu1xsm2i5s1htsno;

drop table if exists name_resource cascade;

create table name_resource
(
    name_resources_id int8,
    resource_id       int8
);

alter table if exists name_resource
    add constraint FK_r3fxh26pbju4ibi35sxxr5oyy
        foreign key (resource_id)
            references resource;

alter table if exists name_resource
    add constraint FK_kfyo6ydiecu1xsm2i5s1htsno
        foreign key (name_resources_id)
            references name;

GRANT SELECT, INSERT, UPDATE, DELETE ON name_resource TO webapni;
GRANT SELECT ON name_resource TO read_only;

-- version
UPDATE db_version
SET version = 34
WHERE id = 1;
