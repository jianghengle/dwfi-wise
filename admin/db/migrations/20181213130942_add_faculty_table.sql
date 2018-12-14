-- +micrate Up
CREATE TABLE faculty(
  id BIGSERIAL PRIMARY KEY,
  people_id INTEGER references people(id),
  yearJoined INTEGER,
  status character varying,
  campus character varying,
  department character varying,
  area_of_expertise character varying,
  expertise_title character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE faculty;
