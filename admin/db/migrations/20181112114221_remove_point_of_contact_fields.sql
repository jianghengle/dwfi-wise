-- +micrate Up
ALTER TABLE programs DROP COLUMN point_of_contact;
ALTER TABLE projects DROP COLUMN point_of_contact;
ALTER TABLE events DROP COLUMN point_of_contact;
ALTER TABLE visiting_scholars DROP COLUMN point_of_contact;


-- +micrate Down
ALTER TABLE programs ADD COLUMN point_of_contact character varying;
ALTER TABLE projects ADD COLUMN point_of_contact character varying;
ALTER TABLE events ADD COLUMN point_of_contact character varying;
ALTER TABLE visiting_scholars ADD COLUMN point_of_contact character varying;
