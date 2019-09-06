SELECT
    mentor.id as mentor_id,
    mentor.first_name as mentor_first_name,
    mentor.last_name as mentor_last_name,
    mentor.email as mentor_email,
    mentee.id as mentee_id,
    mentee.first_name as mentee_first_name,
    mentee.last_name as mentee_last_name,
    mentee.email as mentee_email
FROM
    users mentor
        JOIN mentorings
             ON mentor.id = mentorings.mentor_id
        JOIN users mentee
             ON mentee.id = mentorings.mentee_id