-- +micrate Up
ALTER TABLE publications ADD COLUMN focus_area character varying;


-- +micrate Down
ALTER TABLE publications DROP COLUMN focus_area;
