-- returns whether a user has a global permission via role
SELECT EXISTS (
	SELECT 1
	FROM users usr
	JOIN roles rol ON usr.role_id = rol.id
	JOIN role_permissions rp ON rol.id = rp.role_id
	JOIN permissions per ON rp.permission_id = per.id
	WHERE usr.id = $1
	  AND per.name = $2
) AS "has_permission";

-- returns whether a user has a specific permission for an entity
SELECT EXISTS (
	SELECT 1
	FROM entity_permissions ep
	JOIN permissions per ON ep.permission_id = per.id
	WHERE ep.user_id = $1
		AND per.name = $2
		AND ep.entity_id = $3
		AND ep.is_denied = false
) AS "has_permission";

-- -- Checks if a user has a specific or global permission for an entity, ensuring no explicit denial.
WITH user_specific_permission AS (
	SELECT 1
	FROM entity_permissions ep
	JOIN permissions per ON ep.permission_id = per.id
	WHERE ep.user_id = $1
		AND per.name = $2
		AND ep.entity_id = $3
		AND ep.is_denied = false
),
user_denied_permission AS (
	SELECT 1
	FROM entity_permissions ep
	JOIN permissions per ON ep.permission_id = per.id
	WHERE ep.user_id = $1
		AND per.name = $2
		AND ep.entity_id = $3
		AND ep.is_denied = true
),
user_global_permission AS (
	SELECT 1
	FROM users usr
	JOIN roles rol ON usr.role_id = rol.id
	JOIN role_permissions rp ON rol.id = rp.role_id
	JOIN permissions per ON rp.permission_id = per.id
	WHERE usr.id = $1
	  AND per.name = $2
)
SELECT 
	(NOT EXISTS (SELECT * FROM user_denied_permission))
	AND (EXISTS (SELECT * FROM user_specific_permission)
		OR EXISTS (SELECT * FROM user_global_permission)
	) AS "has_permission";

SELECT * FROM entity_permissions;

-- returns all the permissions of a user in an entity
SELECT json_agg(json_build_object('permission', p.name, 'is_denied', ep.is_denied)) AS permissions
FROM entity_permissions ep
JOIN permissions p ON ep.permission_id = p.id
WHERE ep.user_id = $1
  AND ep.entity_id = $2;
