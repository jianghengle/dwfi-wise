-- +micrate Up
ALTER TABLE publications ADD COLUMN country character varying;


-- +micrate Down
ALTER TABLE publications DROP COLUMN country;
