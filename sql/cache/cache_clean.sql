DELETE FROM sudo_cache WHERE expiry < UNIX_TIMESTAMP(NOW()) AND expiry <> -1