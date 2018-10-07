-- +micrate Up
CREATE TABLE file_relations(
  id BIGSERIAL PRIMARY KEY,
  file_id INTEGER references files(id),
  for_table character varying,
  for_id INTEGER,
  comment character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE file_relations;
