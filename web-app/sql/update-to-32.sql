drop table if exists distribution;

drop table if exists dist_entry_dist_status;
drop table if exists dist_status_dist_status;
drop table if exists dist_entry cascade;
drop table if exists dist_region cascade;
drop table if exists dist_status cascade;

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
    def_link         varchar(255),
    name             varchar(255)                              not null,
    sort_order       int4    default 0                         not null,
    primary key (id)
);

create table dist_status
(
    id               int8    default nextval('nsl_global_seq') not null,
    lock_version     int8    default 0                         not null,
    deprecated       boolean default false                     not null,
    description_html text,
    def_link         varchar(255),
    name             varchar(255)                              not null,
    sort_order       int4    default 0                         not null,
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

-- set up APC regions
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Western Australia', null, 'WA', 1);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Cocos (Keeling) Islands', null, 'CoI', 2);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Christmas Island', null, 'ChI', 3);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Ashmore Reef', null, 'AR', 4);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Cartier Island', null, 'CaI', 5);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Northern Territory', null, 'NT', 6);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('South Australia', null, 'SA', 7);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Queensland', null, 'Qld', 8);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Coral Sea Islands', null, 'CSI', 9);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('New South Wales', null, 'NSW', 10);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Lord Howe Island', null, 'LHI', 11);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Norfolk Island', null, 'NI', 12);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Australian Capital Australian Capital Territory excl. Jervis Bay', null, 'ACT', 13);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Victoria', null, 'Vic', 14);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Tasmainia', null, 'Tas', 15);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Heard Island', null, 'HI', 16);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('McDonald Island', null, 'MDI', 17);
INSERT INTO public.dist_region (description_html, def_link, name, sort_order) VALUES ('Macquarie Island', null, 'MI', 18);

-- set up APC statuses
INSERT INTO public.dist_status (description_html, def_link, name, sort_order) VALUES ('a native taxon that no longer occurs in the given jurisdiction', null, 'presumed extinct', 4);
INSERT INTO public.dist_status (description_html, def_link, name, sort_order) VALUES ('taxa that are represented by one or more naturalised populations in a given jurisdiction, but the extent of naturalisation is uncertain and populations may or may not persist in the longer term.', null, 'doubtfully naturalised', 3);
INSERT INTO public.dist_status (description_html, def_link, name, sort_order) VALUES ('non-native or native taxa previously recorded as being naturalised in a given jurisdiction but of which no collections have been made within a defined timeframe.', null, 'formerly naturalised', 2);
INSERT INTO public.dist_status (description_html, def_link, name, sort_order) VALUES ('<p>plant taxa in a given jurisdiction where:</p>
<ul>
    <li>a native taxon has become naturalised outside of its natural range within that jurisdiction, or;</li>
    <li>a native or non-native taxon that did not originate in a given jurisdiction but has since arrived and become established there.</li>
</ul>', null, 'naturalised', 1);
INSERT INTO public.dist_status (description_html, def_link, name, sort_order) VALUES ('“taxa that have originated in a given area without human involvement or that have arrived there without intentional or unintentional intervention of humans from an area in which they are native” (definition from Pysek et al. (2004)).', null, 'native', 0);
INSERT INTO public.dist_status (description_html, def_link, name, sort_order) VALUES ('For some taxa there is uncertainty as to whether the populations present in a given jurisdiction represent native or naturalised plants or a combination of the two former categories. In these cases, the jurisdiction is listed with the parenthetical qualifier “(uncertain origin)”. Comment fields may be added under the APC reference to indicate the nature of this uncertainty.', null, 'uncertain origin', 5);
INSERT INTO public.dist_status (description_html, def_link, name, sort_order) VALUES ('plant names may be excluded from the Australian Plant Census for a variety of reasons, including taxonomic change, insufficient information to identify the taxon, and erroneous reports. Introduced taxa may be excluded on the basis of their distribution when they have recorded as occurring within a given jurisdiction but there is no evidence of their occurrence or establishment. This includes taxa that may have been reported as naturalised but that are subsequently determined to be present only in cultivation.', null, 'Excluded', 6);

-- version
UPDATE db_version
SET version = 32
WHERE id = 1;
