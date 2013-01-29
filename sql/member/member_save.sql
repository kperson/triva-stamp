INSERT INTO member
(
  member_id,
  user_name,
  updated_at,
  created_at
)
VALUES (
  ?,
  ?,
  NOW(),
  NOW()
)
ON DUPLICATE KEY UPDATE
  updated_at = NOW(),
  user_name = VALUES(user_name)
