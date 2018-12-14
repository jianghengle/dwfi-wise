-- +micrate Up
CREATE TABLE work_plans(
  id BIGSERIAL PRIMARY KEY,
  faculty_id INTEGER references faculty(id),
  year INTEGER,
  plan character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE work_plans;
