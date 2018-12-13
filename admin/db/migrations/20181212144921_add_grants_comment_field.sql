-- +micrate Up
ALTER TABLE grants ADD COLUMN comment character varying;


-- +micrate Down
ALTER TABLE grants DROP COLUMN comment;
