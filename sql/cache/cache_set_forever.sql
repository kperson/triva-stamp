INSERT IGNORE INTO sudo_cache (key_name, yaml_value, expiry)
VALUES(?, ?, -1)
ON DUPLICATE KEY UPDATE yaml_value = VALUES(yaml_value), expiry = VALUES(expiry)