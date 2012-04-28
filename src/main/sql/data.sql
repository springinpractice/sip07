insert into account values
    (1, 'paula', 'p@ssword', 'Paula', 'Cazares', 'paula.cazares@example.com', 1),
    (2, 'daniel', 'p@ssword', 'Daniel', 'Cazares', 'daniel.cazares@example.com', 1),
    (3, 'julia', 'p@ssword', 'Julia', 'Cazares', 'julia.cazares@example.com', 1),
    (4, 'elvira', 'p@ssword', 'Elvira', 'Cazares', 'elvira.cazares@example.com', 1),
    (5, 'juan', 'p@ssword', 'Juan', 'Cazares', 'juan.cazares@example.com', 1);

insert into role values
    (1, 'ROLE_USER'),
    (2, 'ROLE_ADMIN'),
    (3, 'ROLE_STUDENT'),
    (4, 'ROLE_FACULTY');

insert into permission values
    (1, 'PERM_CREATE_ACCOUNTS'),
    (2, 'PERM_READ_ACCOUNTS'),
    (3, 'PERM_UPDATE_ACCOUNTS'),
    (4, 'PERM_DELETE_ACCOUNTS'),
    (5, 'PERM_ADMIN_ACCOUNTS'),
    (6, 'PERM_CREATE_FORUMS'),    
    (7, 'PERM_READ_FORUMS'),
    (8, 'PERM_UPDATE_FORUMS'),
    (9, 'PERM_DELETE_FORUMS'),
    (10, 'PERM_ADMIN_FORUMS'),
    (11, 'PERM_CREATE_MESSAGES'),
    (12, 'PERM_READ_MESSAGES'),
    (13, 'PERM_UPDATE_MESSAGES'),
    (14, 'PERM_DELETE_MESSAGES'),
    (15, 'PERM_ADMIN_MESSAGES');

insert into account_role (account_id, role_id) values
    (1, 1), -- paula is a user
    (2, 1), -- daniel is a user
    (2, 3), -- daniel is a student
    (3, 1), -- julia is a user
    (3, 4), -- julia is a faculty member
    (4, 1), -- elvira is a user
    (4, 3), -- elvira is a student
    (4, 4), -- elvira is a faculty member
    (5, 1), -- juan is a user
    (5, 2); -- juan is an admin

insert into role_permission (role_id, permission_id) values
    (1, 2), -- user can read accounts
    (1, 7), -- user can read forums
    (1, 11), -- user can create messages
    (1, 12), -- user can read messages
    (2, 13), -- admin can update messages
    (2, 14), -- admin can delete messages
    (2, 15); -- admin can admin messages

call createForum(3, 'Algebra I', @fid);
call createMessage(@fid, 3, '2012-09-28 12:34:03', 'What *is* a variable?');
call createMessage(@fid, 5, '2012-09-30 12:34:19', 'This class is too hard');
call createMessage(@fid, 3, '2012-10-01 14:05:21', 'Curses, Descartes');

call createForum(3, 'Algebra II/Trigonometry', @fid);
call createMessage(@fid, 4, '2012-09-29 04:01:39', 'now i know how tall that pyramid is');
call createMessage(@fid, 1, '2012-09-30 16:04:11', 'When will I ever use this??');

call createMessage(@fid, 4, '2012-09-30 14:30:21', 'buy v1@gRA 0nL1n3!');
update message set visible = 0 where id = last_insert_id();

call createMessage(@fid, 2, '2012-10-01 19:37:00', 'Solving system of linear equations');
call createMessage(@fid, 2, '2012-10-01 21:58:42', 'Need help applying Gaussian elimination');

call createForum(3, 'Precalculus', @fid);
call createMessage(@fid, 3, '2012-09-27 16:32:09', 'formula for computing the volume of a sphere');
call createMessage(@fid, 5, '2012-10-01 17:48:02', 'Isn''t a 96-gon basically the same as a circle');
call createMessage(@fid, 3, '2012-10-01 17:53:36', 'Join my precalc Facebook group');

call createForum(4, 'Calculus I', @fid);

call createForum(4, 'Calculus II', @fid);
call createMessage(@fid, 4, '2012-09-27 12:34:56', 'Relationship between differentiation and integration');
call createMessage(@fid, 2, '2012-09-30 12:43:45', 'Integrating a volume');
call createMessage(@fid, 1, '2012-10-01 08:23:02', 'epsilon-delta definition of a limit');
call createMessage(@fid, 3, '2012-10-01 09:56:39', 'Newton or Leibniz');
call createMessage(@fid, 3, '2012-10-01 11:02:01', 'Help!!! Too many integration rules');

call createForum(4, 'Model theory of second-order intuitionistic modal logics', @fid);
call createMessage(@fid, 4, '2012-09-23 14:29:06', 'Possible worlds semantics');
call createMessage(@fid, 2, '2012-09-28 14:31:22', 'Kripke on naming and necessity');
call createMessage(@fid, 3, '2012-09-30 16:17:16', 'Nonconstructive proof that P != NP. Is it good enough??');
call createMessage(@fid, 1, '2012-09-30 19:43:53', 'Who is Archimedes Plutonium?');
