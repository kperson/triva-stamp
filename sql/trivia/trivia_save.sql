INSERT INTO trivia
  (
    trivia_id,
    member_id,
    key_name,
    created_at,
    updated_at,
    trivia_name
  )
  VALUES(
    ?,
    ?,
    ?,
    NOW(),
    NOW(),
    ?
  )
  ON DUPLICATE KEY UPDATE
  updated_at = NOW()