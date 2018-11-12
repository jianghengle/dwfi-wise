-- +micrate Up
ALTER TABLE publications ADD COLUMN point_of_contact INTEGER;


-- +micrate Down
ALTER TABLE publications DROP COLUMN point_of_contact;
