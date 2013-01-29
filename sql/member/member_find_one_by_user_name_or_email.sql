SELECT m.*, ep.password, ep.email
FROM
    member m
    JOIN email_password ep ON m.member_id = ep.member_id
WHERE
    m.user_name = ? OR ep.email = ?