-- +micrate Up
CREATE TABLE events(
  id BIGSERIAL PRIMARY KEY,
  title character varying,
  description character varying,
  status character varying,
  country character varying,
  state character varying,
  focus_area character varying,
  start_date timestamp without time zone,
  end_date timestamp without time zone,
  funding character varying,
  collaborators character varying,
  more_information character varying,
  point_of_contact character varying,
  website character varying,
  is_published bool,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE events;