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

-- functions to construct display distribution string from the DB

drop function if exists dist_entry_status(BIGINT);
create function dist_entry_status(entry_id BIGINT)
    returns text
    language sql as
$$
with status as (
    SELECT string_agg(ds.name, ' and ') status
    from (
             select ds.name
             FROM dist_entry de
                      join dist_region dr on de.region_id = dr.id
                      join dist_entry_dist_status deds on de.id = deds.dist_entry_status_id
                      join dist_status ds on deds.dist_status_id = ds.id
             where de.id = entry_id
             order by ds.sort_order) ds
)
select case
           when status.status = 'native' then
               ''
           else
                   '(' || status.status || ')'
           end
from status;
$$;

drop function if exists distribution(BIGINT);
create function distribution(element_id BIGINT)
    returns text
    language sql as
$$
select string_agg(entries.entry, ', ')
from (SELECT case
                 when status = '' then
                     dr.name
                 else
                         dr.name || ' ' || status
                 end as entry
      FROM dist_entry de
               join dist_region dr on de.region_id = dr.id,
           dist_entry_status(de.id) status
      where de.tree_element_id = element_id
      order by dr.sort_order
     ) entries
$$;

-- import existing data

-- create a light version of tmp_distribution table but including old tree elements.
DROP TABLE IF EXISTS tmp_distribution;
SELECT dist,
       te.id                                                                                                                                AS apc_te_id,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](WA(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)')  AS wa,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](CoI(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)') AS CoI,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](ChI(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)') AS ChI,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](AR(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)')  AS AR,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](CaI(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)') AS CaI,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](NT(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)')  AS NT,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](SA(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)')  AS SA,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](Qld(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)') AS Qld,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](CSI(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)') AS CSI,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](NSW(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)') AS NSW,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](LHI(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)') AS LHI,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](NI(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)')  AS NI,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](ACT(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)') AS ACT,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](Vic(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)') AS Vic,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](Tas(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)') AS Tas,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](HI(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)')  AS HI,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](MDI(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)') AS MDI,
       SUBSTRING(' ' || dist FROM
                 '(?i)[^A-Za-z](MI(?![a-z]).*?)(((,|, +| +)\??(WA|CoI|ChI|AR|CaI|NT|SA|Qld|CSI|NSW|LHI|NI|ACT|Vic|Tas|HI|MDI|MI))|,? *$)')  AS MI
INTO tmp_distribution
FROM tree_element te,
     latest_accepted_profile(te.instance_id) as profile,
     regexp_replace(profile.dist_value, E'[\\n\\r\\u2028]+', ' ', 'g') AS dist;

-- create a dist entry with region for each existing distribution
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.WA is not null and region.name = 'WA';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.CoI is not null and region.name = 'CoI';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.ChI is not null and region.name = 'ChI';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.AR is not null and region.name = 'AR';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.CaI is not null and region.name = 'CaI';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.NT is not null and region.name = 'NT';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.SA is not null and region.name = 'SA';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.Qld is not null and region.name = 'Qld';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.CSI is not null and region.name = 'CSI';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.NSW is not null and region.name = 'NSW';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.LHI is not null and region.name = 'LHI';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.NI is not null and region.name = 'NI';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.ACT is not null and region.name = 'ACT';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.Vic is not null and region.name = 'Vic';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.Tas is not null and region.name = 'Tas';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.HI is not null and region.name = 'HI';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.MDI is not null and region.name = 'MDI';
insert into dist_entry (region_id, tree_element_id) select region.id, apc_te_id from tmp_distribution dist, dist_region region where dist.MI is not null and region.name = 'MI';

-- add each status to created entries

    -- turn naturalised into a reg ex that excludeds doubtfully and formerly
update dist_status set name = '[^y][ ,(]naturalised' where name = 'naturalised';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.WA ~* ds.name where  dr.name = 'WA';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.CoI ~* ds.name where  dr.name = 'CoI';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.ChI ~* ds.name where  dr.name = 'ChI';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.AR ~* ds.name where  dr.name = 'AR';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.CaI ~* ds.name where  dr.name = 'CaI';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.NT ~* ds.name where  dr.name = 'NT';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.SA ~* ds.name where  dr.name = 'SA';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.Qld ~* ds.name where  dr.name = 'Qld';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.CSI ~* ds.name where  dr.name = 'CSI';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.NSW ~* ds.name where  dr.name = 'NSW';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.LHI ~* ds.name where  dr.name = 'LHI';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.NI ~* ds.name where  dr.name = 'NI';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.ACT ~* ds.name where  dr.name = 'ACT';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.Vic ~* ds.name where  dr.name = 'Vic';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.Tas ~* ds.name where  dr.name = 'Tas';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.HI ~* ds.name where  dr.name = 'HI';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.MDI ~* ds.name where  dr.name = 'MDI';
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id) select de.id, ds.id from dist_entry de join dist_region dr on de.region_id = dr.id join tmp_distribution dist on de.tree_element_id = dist.apc_te_id join dist_status ds on dist.MI ~* ds.name where  dr.name = 'MI';
-- set naturalised back to what it should be
update dist_status set name = 'naturalised' where name = '[^y][ ,(]naturalised';

-- insert the default native status where there is no status for an entry
insert into dist_entry_dist_status (dist_entry_status_id, dist_status_id)
select de.id, ds.id
from dist_entry de
         join dist_region dr on de.region_id = dr.id
         left outer join dist_entry_dist_status deds on de.id = deds.dist_entry_status_id,
     dist_status ds
where deds is null
  and ds.name = 'native';

-- version
UPDATE db_version
SET version = 32
WHERE id = 1;
