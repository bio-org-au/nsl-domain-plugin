alter table reference drop column if exists iso_publication_date;

alter table reference add column iso_publication_date date;

-- version
UPDATE db_version
SET version = 33
WHERE id = 1;
