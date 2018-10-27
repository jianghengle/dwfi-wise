-- +micrate Up
CREATE TABLE grant_relations(
  id BIGSERIAL PRIMARY KEY,
  grant_id INTEGER references grants(id),
  for_table character varying,
  for_id INTEGER,
  comment character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE grant_relations;