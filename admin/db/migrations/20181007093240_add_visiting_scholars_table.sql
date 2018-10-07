-- +micrate Up
CREATE TABLE visiting_scholars(
  id BIGSERIAL PRIMARY KEY,
  first_name character varying,
  last_name character varying,
  country character varying,
  state character varying,
  research_topic character varying,
  description character varying,
  status character varying,
  focus_area character varying,
  start_date timestamp without time zone,
  end_date timestamp without time zone,
  funding character varying,
  collaborators character varying,
  more_information character varying,
  point_of_contact character varying,
  is_published bool,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE visiting_scholars;