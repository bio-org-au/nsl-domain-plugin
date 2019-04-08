drop table if exists distribution;

drop table if exists dist_entry_dist_status;
drop table if exists dist_status_dist_status;
drop table if exists dist_enty;
drop table if exists dist_region;
drop table if exists dist_status;

create table dist_entry
(
    id              int8 default nextval('nsl_global_seq') not null,
    lock_version    int8 default 0                         not null,
    region_id       int8                                   not null,
    tree_element_id int8                                   not null,
    primary key (id)
);

create table dist_entry_dist_status
(
    dist_entry_status_id int8,
    dist_status_id       int8
);

create table dist_region
(
    id               int8    default nextval('nsl_global_seq') not null,
    lock_version     int8    default 0                         not null,
    deprecated       boolean default false                     not null,
    description_html text,
    name             varchar(255)                              not null,
    primary key (id)
);

create table dist_status
(
    id               int8    default nextval('nsl_global_seq') not null,
    lock_version     int8    default 0                         not null,
    deprecated       boolean default false                     not null,
    description_html text,
    name             varchar(255)                              not null,
    primary key (id)
);

create table dist_status_dist_status
(
    dist_status_combining_status_id int8,
    dist_status_id                  int8
);

alter table if exists dist_entry
    add constraint FK_ffleu7615efcrsst8l64wvomw
        foreign key (region_id)
            references dist_region;

alter table if exists dist_entry
    add constraint FK_d9a9gcy3hbk8s5slosux1k5uc
        foreign key (tree_element_id)
            references tree_element;

alter table if exists dist_entry_dist_status
    add constraint FK_jnh4hl7ev54cknuwm5juvb22i
        foreign key (dist_status_id)
            references dist_status;

alter table if exists dist_entry_dist_status
    add constraint FK_cpmfv1d7wlx26gjiyxrebjvxn
        foreign key (dist_entry_status_id)
            references dist_entry;

alter table if exists dist_status_dist_status
    add constraint FK_g38me2w6f5ismhdjbj8je7nv0
        foreign key (dist_status_id)
            references dist_status;

alter table if exists dist_status_dist_status
    add constraint FK_q0p6tn5peagvsl7xmqcy39yuh
        foreign key (dist_status_combining_status_id)
            references dist_status;

alter table dist_entry
    add constraint de_unique_region unique (region_id, tree_element_id);

-- version
UPDATE db_version
SET version = 32
WHERE id = 1;
