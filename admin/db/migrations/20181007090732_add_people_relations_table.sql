-- +micrate Up
CREATE TABLE people_relations(
  id BIGSERIAL PRIMARY KEY,
  people_id INTEGER references people(id),
  for_table character varying,
  for_id INTEGER,
  role character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE people_relations;