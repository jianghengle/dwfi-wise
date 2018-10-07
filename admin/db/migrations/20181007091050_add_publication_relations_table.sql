-- +micrate Up
CREATE TABLE publication_relations(
  id BIGSERIAL PRIMARY KEY,
  publication_id INTEGER references publications(id),
  for_table character varying,
  for_id INTEGER,
  comment character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE publication_relations;