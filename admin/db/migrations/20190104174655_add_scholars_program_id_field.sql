-- +micrate Up
ALTER TABLE visiting_scholars ADD COLUMN program_id INTEGER references programs(id);


-- +micrate Down
ALTER TABLE visiting_scholars DROP COLUMN program_id;
