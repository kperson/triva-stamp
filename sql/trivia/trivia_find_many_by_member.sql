SELECT
  sc.yaml_value
FROM
  trivia t
  JOIN member m ON t.member_id = m.member_id
  JOIN sudo_cache sc ON t.key_name = sc.key_name
WHERE m.member_id = ?
ORDER BY
  t.updated_at DESC
LIMIT %s, %s