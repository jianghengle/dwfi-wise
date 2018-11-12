-- +micrate Up
ALTER TABLE publications DROP COLUMN point_of_contact;


-- +micrate Down
ALTER TABLE publications ADD COLUMN point_of_contact character varying;
