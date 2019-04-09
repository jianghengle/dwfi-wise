-- +micrate Up
ALTER TABLE projects ADD COLUMN request character varying;
ALTER TABLE projects ADD COLUMN progress character varying;
ALTER TABLE projects ADD COLUMN progress_time timestamp without time zone;


-- +micrate Down
ALTER TABLE projects DROP COLUMN request;
ALTER TABLE projects DROP COLUMN progress;
ALTER TABLE projects DROP COLUMN progress_time;

