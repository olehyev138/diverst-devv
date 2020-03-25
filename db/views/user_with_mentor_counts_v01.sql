SELECT
    u.id as user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(DISTINCT m1.mentee_id) as number_of_mentees,
    COUNT(DISTINCT m2.mentor_id) as number_of_mentors
FROM
    users u
    LEFT JOIN mentorings m1
        ON u.id = m1.mentor_id
    LEFT JOIN mentorings m2
        ON u.id = m2.mentee_id
GROUP BY
    u.id,
    u.first_name,
    u.last_name,
    u.email;