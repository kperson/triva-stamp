INSERT INTO sudo_cache (key_name, yaml_value, expiry)
VALUES(?, ?, UNIX_TIMESTAMP(NOW()) + ?)
ON DUPLICATE KEY UPDATE yaml_value = VALUES(yaml_value), expiry = VALUES(expiry)