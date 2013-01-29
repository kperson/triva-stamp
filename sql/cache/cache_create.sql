CREATE TABLE sudo_cache (
  key_name varchar(255) NOT NULL,
  yaml_value text NOT NULL,
  expiry bigint(20) NOT NULL,
  PRIMARY KEY (key_name)
)