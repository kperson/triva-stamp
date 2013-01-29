SELECT
  sc.yaml_value
FROM
  trivia t
  JOIN sudo_cache sc ON t.key_name = sc.key_name
WHERE
  t.member_id = ?
  AND t.trivia_id = ?