INSERT INTO
	"roles" ("name")
VALUES ('parishioner'), ('priest'), ('admin'), ('admin_diocesan');

INSERT INTO
	"users" ("name", "email", "password", "role_id")
VALUES
	('John', 'john@mail.com', 'any_password', 1),
	('Pe. Felipe Neri', 'felipe@mail.com', 'any_password', 2),
	('Admin', 'admin@mail.com', 'any_password', 3),
	('St. Pio X', 'piusx@mail.com', 'any_password', 4);

INSERT INTO
	entity_types ("name")
VALUES ('parish'), ('chapel'), ('priest');

INSERT INTO
	"permissions" ("name", "description", "entity_type_id")
VALUES
	('edit_parish', 'Permission to edit parishes', 1),
	('edit_chapel', 'Permission to edit chapels', 2),
	('delete_parish', 'Permission to delete parishes', 1),
	('delete_chapel', 'Permission to delete chapels', 2),
	('transfer_priest', 'Permission to transfer priest from parish', 3);

INSERT INTO
	role_permissions ("role_id", "permission_id")
VALUES
	(3,1), (3,2), (3,3), (3,5), (4,1), (4,2), (4,3), (4,4), (4,5);

INSERT INTO
	entity_permissions ("entity_id", "user_id", "permission_id", "is_denied")
VALUES
	(1,1,2,false),
	(1,1,1,false),
	(1,3,3,true),
	(2,2,5,false);
