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

insert into dist_status_dist_status (dist_status_combining_status_id, dist_status_id)
    (SELECT comb.id, ds.id from dist_status ds, dist_status comb where ds.name = 'naturalised' and comb.name = 'uncertain origin');
insert into dist_status_dist_status (dist_status_combining_status_id, dist_status_id)
    (SELECT comb.id, ds.id from dist_status ds, dist_status comb where ds.name = 'native' and comb.name = 'naturalised');
insert into dist_status_dist_status (dist_status_combining_status_id, dist_status_id)
    (SELECT comb.id, ds.id from dist_status ds, dist_status comb where ds.name = 'native' and comb.name = 'formerly naturalised');
insert into dist_status_dist_status (dist_status_combining_status_id, dist_status_id)
    (SELECT comb.id, ds.id from dist_status ds, dist_status comb where ds.name = 'native' and comb.name = 'doubtfully naturalised');
insert into dist_status_dist_status (dist_status_combining_status_id, dist_status_id)
    (SELECT comb.id, ds.id from dist_status ds, dist_status comb where ds.name = 'native' and comb.name = 'uncertain origin');


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

-- NSL-3284 fix kingdom and ccAttributionIRI field names in taxon export

-- first fix synonyms data in some tree_elements
update tree_element
set synonyms = regexp_replace(synonyms ::text, 'https://id.biodiversity.org.au/', '/', 'g') :: JSONB
where (synonyms :: text) ~ 'https://id.biodiversity.org.au/';

update tree_element
set synonyms = regexp_replace(synonyms ::text, '"host": "id.biodiversity.org.au"', '"host": "https://id.biodiversity.org.au"', 'g') :: JSONB
where (synonyms :: text) ~ '"host": "id.biodiversity.org.au"';

update tree_element
set synonyms = regexp_replace(synonyms ::text, '_link": "([^/])', '_link": "/\1', 'g') :: JSONB
where (synonyms :: text) ~ '_link": "[^/]';

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
    (SELECT (syn ->> 'host') || (syn ->> 'concept_link')                                                      AS "taxonID",
            acc_nt.name                                                                                     AS "nameType",
            tree.host_name || tve.element_link                                                              AS "acceptedNameUsageID",
            acc_name.full_name                                                                              AS "acceptedNameUsage",
            CASE
                WHEN acc_ns.name NOT IN ('legitimate', '[default]')
                    THEN acc_ns.name
                ELSE NULL END                                                                               AS "nomenclaturalStatus",
            (syn ->> 'type')                                                                                AS "taxonomicStatus",
            (syn ->> 'type' ~ 'parte')                                                                      AS "proParte",
            syn_name.full_name                                                                              AS "scientificName",
            (syn ->> 'host') || (syn ->> 'name_link')                                                       AS "scientificNameID",
            syn_name.simple_name                                                                            AS "canonicalName",
            CASE
                WHEN syn_nt.autonym
                    THEN NULL
                ELSE regexp_replace(substring(syn_name.full_name_html FROM '<authors>(.*)</authors>'), '<[^>]*>', '',
                                    'g')
                END                                                                                         AS "scientificNameAuthorship",
            -- only in accepted names
            NULL                                                                                            AS "parentNameUsageID",
            syn_rank.name                                                                                   AS "taxonRank",
            syn_rank.sort_order                                                                             AS "taxonRankSortOrder",
            (SELECT name_element
             FROM find_tree_rank(tve.element_link, 10)
             ORDER BY sort_order ASC
             LIMIT 1)                                                                                       AS "kingdom",
            -- the below works but is a little slow
            -- find another efficient way to do it.
            (SELECT name_element FROM find_tree_rank(tve.element_link, 30) ORDER BY sort_order ASC LIMIT 1) AS "class",
            (SELECT name_element
             FROM find_tree_rank(tve.element_link, 40)
             ORDER BY sort_order ASC
             LIMIT 1)                                                                                       AS "subclass",
            (SELECT name_element FROM find_tree_rank(tve.element_link, 80) ORDER BY sort_order ASC LIMIT 1) AS "family",
            syn_name.created_at                                                                             AS "created",
            syn_name.updated_at                                                                             AS "modified",
            tree.name                                                                                       AS "datasetName",
            (syn ->> 'host') || (syn ->> 'concept_link')                                                    AS "taxonConceptID",
            (syn ->> 'cites')                                                                               AS "nameAccordingTo",
            (syn ->> 'host') || (syn ->> 'cites_link')                                                      AS "nameAccordingToID",
            profile -> (tree.config ->> 'comment_key') ->> 'value'                                          AS "taxonRemarks",
            profile -> (tree.config ->> 'distribution_key') ->> 'value'                                     AS "taxonDistribution",
            -- todo check this is ok for synonyms
            regexp_replace(tve.name_path, '/', '|', 'g')                                                    AS "higherClassification",
            CASE
                WHEN firstHybridParent.id IS NOT NULL
                    THEN firstHybridParent.full_name
                ELSE NULL END                                                                               AS "firstHybridParentName",
            CASE
                WHEN firstHybridParent.id IS NOT NULL
                    THEN tree.host_name || '/' || firstHybridParent.uri
                ELSE NULL END                                                                               AS "firstHybridParentNameID",
            CASE
                WHEN secondHybridParent.id IS NOT NULL
                    THEN secondHybridParent.full_name
                ELSE NULL END                                                                               AS "secondHybridParentName",
            CASE
                WHEN secondHybridParent.id IS NOT NULL
                    THEN tree.host_name || '/' || secondHybridParent.uri
                ELSE NULL END                                                                               AS "secondHybridParentNameID",
            -- boiler plate stuff at the end of the record
            (select coalesce((SELECT value FROM shard_config WHERE name = 'nomenclatural code'),
                             'ICN')) :: TEXT                                                                AS "nomenclaturalCode",
            'http://creativecommons.org/licenses/by/3.0/' :: TEXT                                           AS "license",
            (syn ->> 'host') || (syn ->> 'instance_link')                                                   AS "ccAttributionIRI"
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
                ELSE NULL END                                                                               AS "nomenclaturalStatus",
            CASE
                WHEN te.excluded
                    THEN 'excluded'
                ELSE 'accepted'
                END                                                                                         AS "taxonomicStatus",
            FALSE                                                                                           AS "proParte",
            acc_name.full_name                                                                              AS "scientificName",
            te.name_link                                                                                    AS "scientificNameID",
            acc_name.simple_name                                                                            AS "canonicalName",
            CASE
                WHEN acc_nt.autonym
                    THEN NULL
                ELSE regexp_replace(substring(acc_name.full_name_html FROM '<authors>(.*)</authors>'), '<[^>]*>', '',
                                    'g')
                END                                                                                         AS "scientificNameAuthorship",
            tree.host_name || tve.parent_id                                                                 AS "parentNameUsageID",
            te.rank                                                                                         AS "taxonRank",
            acc_rank.sort_order                                                                             AS "taxonRankSortOrder",
            (SELECT name_element
             FROM find_tree_rank(tve.element_link, 10)
             ORDER BY sort_order ASC
             LIMIT 1)                                                                                       AS "kingdom",
            -- the below works but is a little slow
            -- find another efficient way to do it.
            (SELECT name_element FROM find_tree_rank(tve.element_link, 30) ORDER BY sort_order ASC LIMIT 1) AS "class",
            (SELECT name_element
             FROM find_tree_rank(tve.element_link, 40)
             ORDER BY sort_order ASC
             LIMIT 1)                                                                                       AS "subclass",
            (SELECT name_element FROM find_tree_rank(tve.element_link, 80) ORDER BY sort_order ASC LIMIT 1) AS "family",
            acc_name.created_at                                                                             AS "created",
            acc_name.updated_at                                                                             AS "modified",
            tree.name                                                                                       AS "datasetName",
            te.instance_link                                                                                AS "taxonConceptID",
            acc_ref.citation                                                                                AS "nameAccordingTo",
            tree.host_name || '/reference/' || lower(name_space.value) || '/' ||
            acc_ref.id                                                                                      AS "nameAccordingToID",
            profile -> (tree.config ->> 'comment_key') ->> 'value'                                          AS "taxonRemarks",
            profile -> (tree.config ->> 'distribution_key') ->> 'value'                                     AS "taxonDistribution",
            -- todo check this is ok for synonyms
            regexp_replace(tve.name_path, '/', '|', 'g')                                                    AS "higherClassification",
            CASE
                WHEN firstHybridParent.id IS NOT NULL
                    THEN firstHybridParent.full_name
                ELSE NULL END                                                                               AS "firstHybridParentName",
            CASE
                WHEN firstHybridParent.id IS NOT NULL
                    THEN tree.host_name || '/' || firstHybridParent.uri
                ELSE NULL END                                                                               AS "firstHybridParentNameID",
            CASE
                WHEN secondHybridParent.id IS NOT NULL
                    THEN secondHybridParent.full_name
                ELSE NULL END                                                                               AS "secondHybridParentName",
            CASE
                WHEN secondHybridParent.id IS NOT NULL
                    THEN tree.host_name || '/' || secondHybridParent.uri
                ELSE NULL END                                                                               AS "secondHybridParentNameID",
            -- boiler plate stuff at the end of the record
            (select coalesce((SELECT value FROM shard_config WHERE name = 'nomenclatural code'),
                             'ICN')) :: TEXT                                                                AS "nomenclaturalCode",
            'http://creativecommons.org/licenses/by/3.0/' :: TEXT                                           AS "license",
            tree.host_name || tve.element_link                                                              AS "ccAttributionIRI"
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
              LEFT OUTER JOIN shard_config name_space on name_space.name = 'name space'
     ORDER BY "higherClassification");

comment on materialized view taxon_view is 'The Taxon View provides a complete list of Names and their synonyms accepted by CHAH in Australia.';
comment on column taxon_view."taxonomicStatus" is 'Is this name accepted, excluded or a synonym of an accepted name.';
comment on column taxon_view."scientificName" is 'The full scientific name including authority.';
comment on column taxon_view."scientificNameID" is 'The identifying URI of the scientific name in this dataset.';
comment on column taxon_view."acceptedNameUsage" is 'The accepted name for this concept in this classification.';
comment on column taxon_view."acceptedNameUsageID" is 'The identifying URI of the accepted name concept.';
comment on column taxon_view."taxonID" is 'The identifying URI of the taxon concept used here. For an accepted name it identifies the taxon concept and what it encloses (subtaxa). For a synonym it identifies the relationship.';
comment on column taxon_view."nameType" is 'A categorisation of the name, e.g. scientific, hybrid, cultivar';
comment on column taxon_view."nomenclaturalStatus" is 'The nomencultural status of this name. http://rs.gbif.org/vocabulary/gbif/nomenclatural_status.xml';
comment on column taxon_view."proParte" is 'A flag that indicates this name is applied to this accepted name in part. If a name is ''pro parte'' then the name will have more than 1 accepted name.';
comment on column taxon_view."canonicalName" is 'The name without authorship.';
comment on column taxon_view."scientificNameAuthorship" is 'Authorship of the name.';
comment on column taxon_view."parentNameUsageID" is 'The identifying URI of the parent taxon for accepted names in the classification.';
comment on column taxon_view."taxonRank" is 'The taxonomic rank of the scientificName.';
comment on column taxon_view."taxonRankSortOrder" is 'A sort order that can be applied to the rank.';
comment on column taxon_view.kingdom is 'The canonical name of the kingdom based on this classification.';
comment on column taxon_view.class is 'The canonical name of the class based on this classification.';
comment on column taxon_view.subclass is 'The canonical name of the subclass based on this classification.';
comment on column taxon_view.family is 'The canonical name of the family based on this classification.';
comment on column taxon_view.created is 'Date the record for this concept was created. Format ISO:86 01';
comment on column taxon_view.modified is 'Date the record for this concept was modified. Format ISO:86 01';
comment on column taxon_view."datasetName" is 'Name of the taxonomy (tree) that contains this concept. e.g. APC, AusMoss';
comment on column taxon_view."taxonConceptID" is 'The identifying URI taxanomic concept this record refers to.';
comment on column taxon_view."nameAccordingTo" is 'The reference citation for this name.';
comment on column taxon_view."nameAccordingToID" is 'The identifying URI for the reference citation for this name.';
comment on column taxon_view."taxonRemarks" is 'Comments made specifically about this name in this classification.';
comment on column taxon_view."taxonDistribution" is 'The State or Territory distribution of the accepted name.';
comment on column taxon_view."higherClassification" is 'A list of names representing the branch down to (and including) this name separated by a "|".';
comment on column taxon_view."firstHybridParentName" is 'The scientificName for the first hybrid parent. For hybrids.';
comment on column taxon_view."firstHybridParentNameID" is 'The identifying URI the scientificName for the first hybrid parent.';
comment on column taxon_view."secondHybridParentName" is 'The scientificName for the second hybrid parent. For hybrids.';
comment on column taxon_view."secondHybridParentNameID" is 'The identifying URI the scientificName for the second hybrid parent.';
comment on column taxon_view."nomenclaturalCode" is 'The nomenclatural code under which this name is constructed.';
comment on column taxon_view.license is 'The license by which this data is being made available.';
comment on column taxon_view."ccAttributionIRI" is 'The attribution to be used when citing this concept.';

GRANT SELECT ON taxon_view to ${webUserName};

-- version
UPDATE db_version
SET version = 32
WHERE id = 1;
