-- +micrate Up
ALTER TABLE programs ADD COLUMN request character varying;
ALTER TABLE programs ADD COLUMN progress character varying;
ALTER TABLE programs ADD COLUMN progress_time timestamp without time zone;


-- +micrate Down
ALTER TABLE programs DROP COLUMN request;
ALTER TABLE programs DROP COLUMN progress;
ALTER TABLE programs DROP COLUMN progress_time;
