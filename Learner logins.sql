-- Code for tableau view to look at YOY growth active users for both Mobile and Web Apps

-- Table with mobile users (teachers) learner logins

DROP TABLE IF EXISTS learner_logins_active_users;

CREATE TABLE learner_logins_active_users
	(app_type INT COMMENT 'Linked to twinkl.twinkl_app_types for mobile apps and 0 for web apps',
	 app_name VARCHAR(25),
	 month DATE,
	 type VARCHAR(25),
	 user VARCHAR(25),
	 count INT,
	 KEY (app_type),
	 KEY (app_name))
	COMMENT '-name-PG-name- -desc-For looking at learner logins through both mobile and web apps-desc- -dim-App product-dim- -gdpr-No issue-gdpr- -type-type-'
SELECT lla.app_type,
			 `at`.`name` AS app_name,
			 DATE_FORMAT(lla.datetime, '%Y-%m-01') AS month, -- Kept the date as 1st of every month, needed only for aggregating every month
			 'mobile' AS type,
			 'teacher' AS user,
			 COUNT(DISTINCT (lla.user_id)) AS count
FROM twinkl.twinkl_login_log_app `lla`
	JOIN twinkl.twinkl_app_types `at`
		ON lla.app_type = `at`.id
GROUP BY month, lla.app_type;

-- Inserting pupils for mobile users
INSERT INTO learner_logins_active_users
SELECT lla.app_type,
			 `at`.`name` AS app_name,
			 DATE_FORMAT(lla.datetime, '%Y-%m-01') AS month,
			 'mobile' AS type,
			 'pupil' AS user,
			 COUNT(DISTINCT (lla.pupil_id)) AS count
FROM twinkl.twinkl_pupil_login_log_app `lla`
	JOIN twinkl.twinkl_app_types `at`
		ON lla.app_type = `at`.id
GROUP BY month, lla.app_type;

-- Inserting pupils and teachers for spelling web app
INSERT INTO learner_logins_active_users
SELECT 0 AS app_type,
			 'Spelling' AS app_name,
			 DATE_FORMAT(played_date, '%Y-%m-01') AS month,
			 'web' AS type,
			 'pupil' AS user,
			 COUNT(DISTINCT (pupil_id)) AS count
FROM spelling_engagement
GROUP BY month

UNION

SELECT 0 AS app_type,
			 'Spelling' AS app_name,
			 DATE_FORMAT(played_date, '%Y-%m-01') AS month,
			 'web' AS type,
			 'teacher' AS user,
			 COUNT(DISTINCT user_id) AS count
FROM spelling_engagement
GROUP BY month;

-- Inserting pupils and teachers for puzzled web app

INSERT INTO learner_logins_active_users
SELECT 0 AS app_type,
			 'Puzzled' AS app_name,
			 DATE_FORMAT(played_date, '%Y-%m-01') AS month,
			 'web' AS type,
			 'pupil' AS user,
			 COUNT(DISTINCT (pupil_id)) AS count
FROM puzzled_engagement
GROUP BY month

UNION

SELECT 0 AS app_type,
			 'Puzzled' AS app_name,
			 DATE_FORMAT(played_date, '%Y-%m-01') AS month,
			 'web' AS type,
			 'teacher' AS user,
			 COUNT(DISTINCT user_id) AS count
FROM puzzled_engagement
GROUP BY month;

-- Inserting pupils and teachers for ESL web app
INSERT INTO learner_logins_active_users
SELECT 0 AS app_type,
			 'ESL' AS app_name,
			 DATE_FORMAT(played_date, '%Y-%m-01') AS month,
			 'web' AS type,
			 'pupil' AS user,
			 COUNT(DISTINCT (pupil_id)) AS count
FROM esl_engagement
GROUP BY month

UNION

SELECT 0 AS app_type,
			 'ESL' AS app_name,
			 DATE_FORMAT(played_date, '%Y-%m-01') AS month,
			 'web' AS type,
			 'teacher' AS user,
			 COUNT(DISTINCT user_id) AS count
FROM esl_engagement
GROUP BY month;

-- Inserting pupils and teachers for Lessons web app
INSERT INTO learner_logins_active_users
SELECT 0 AS app_type,
			 'Lessons' AS app_name,
			 DATE_FORMAT(datetime, '%Y-%m-01') AS month,
			 'web' AS type,
			 'pupil' AS user,
			 COUNT(DISTINCT pupil_id) AS count
FROM twinkl.twinkl_pupil_download_log
WHERE type_id = 1
GROUP BY month

UNION

SELECT 0 AS app_type,
			 'Lessons' AS app_name,
			 DATE_FORMAT(datetime, '%Y-%m-01') AS month,
			 'web' AS type,
			 'teacher' AS user,
			 COUNT(DISTINCT user_id) AS count
FROM twinkl.twinkl_pupil_download_log
WHERE type_id = 1
GROUP BY month;

-- Inserting pupils and teachers for Learn & Go web app
INSERT INTO learner_logins_active_users
SELECT 0 AS app_type,
			 'Learn & Go' AS app_name,
			 DATE_FORMAT(datetime, '%Y-%m-01') AS month,
			 'web' AS type,
			 'pupil' AS user,
			 COUNT(DISTINCT pupil_id) AS count
FROM twinkl.twinkl_pupil_download_log
WHERE type_id = 2
GROUP BY month

UNION

SELECT 0 AS app_type,
			 'Learn & Go' AS app_name,
			 DATE_FORMAT(datetime, '%Y-%m-01') AS month,
			 'web' AS type,
			 'teacher' AS user,
			 COUNT(DISTINCT user_id) AS count
FROM twinkl.twinkl_pupil_download_log
WHERE type_id = 2
GROUP BY month;

-- Inserting pupils and teachers for Rhino Readers Library web app
INSERT INTO learner_logins_active_users
SELECT 0 AS app_type,
			 'Rhino Readers Library' AS app_name,
			 DATE_FORMAT(datetime, '%Y-%m-01') AS month,
			 'web' AS type,
			 'pupil' AS user,
			 COUNT(DISTINCT pupil_id) AS count
FROM twinkl.twinkl_pupil_download_log
WHERE type_id = 3
GROUP BY month

UNION

SELECT 0 AS app_type,
			 'Rhino Readers Library' AS app_name,
			 DATE_FORMAT(datetime, '%Y-%m-01') AS month,
			 'web' AS type,
			 'teacher' AS user,
			 COUNT(DISTINCT user_id) AS count
FROM twinkl.twinkl_pupil_download_log
WHERE type_id = 3
GROUP BY month;