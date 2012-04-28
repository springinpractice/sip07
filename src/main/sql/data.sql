-- =====================================================================================================================
-- Create permissions
-- =====================================================================================================================

call createPermission('PERM_CREATE_ACCOUNTS');
call createPermission('PERM_READ_ACCOUNTS');
call createPermission('PERM_UPDATE_ACCOUNTS');
call createPermission('PERM_DELETE_ACCOUNTS');
call createPermission('PERM_ADMIN_ACCOUNTS');
call createPermission('PERM_CREATE_FORUMS');
call createPermission('PERM_READ_FORUMS');
call createPermission('PERM_UPDATE_FORUMS');
call createPermission('PERM_DELETE_FORUMS');
call createPermission('PERM_ADMIN_FORUMS');
call createPermission('PERM_CREATE_MESSAGES');
call createPermission('PERM_READ_MESSAGES');
call createPermission('PERM_UPDATE_MESSAGES');
call createPermission('PERM_DELETE_MESSAGES');
call createPermission('PERM_ADMIN_MESSAGES');


-- =====================================================================================================================
-- Create roles
-- =====================================================================================================================

call createRole('ROLE_USER', @rid);
call bindRoleAndPermission(@rid, 'PERM_READ_ACCOUNTS');
call bindRoleAndPermission(@rid, 'PERM_READ_FORUMS');
call bindRoleAndPermission(@rid, 'PERM_CREATE_MESSAGES');
call bindRoleAndPermission(@rid, 'PERM_READ_MESSAGES');

call createRole('ROLE_ADMIN', @rid);
call bindRoleAndPermission(@rid, 'PERM_UPDATE_MESSAGES');
call bindRoleAndPermission(@rid, 'PERM_DELETE_MESSAGES');
call bindRoleAndPermission(@rid, 'PERM_ADMIN_MESSAGES');

call createRole('ROLE_STUDENT', @rid);
call createRole('ROLE_FACULTY', @rid);


-- =====================================================================================================================
-- Create accounts
-- =====================================================================================================================

call createAccount('paula', 'Paula', 'Cazares', 'paula@example.com', @uid);
call bindAccountAndRole(@uid, 'ROLE_USER');

call createAccount('daniel', 'Daniel', 'Cazares', 'daniel@example.com', @uid);
call bindAccountAndRole(@uid, 'ROLE_USER');
call bindAccountAndRole(@uid, 'ROLE_STUDENT');

call createAccount('julia', 'Julia', 'Cazares', 'julia@example.com', @uid);
call bindAccountAndRole(@uid, 'ROLE_USER');
call bindAccountAndRole(@uid, 'ROLE_FACULTY');

call createAccount('elvira', 'Elvira', 'Cazares', 'elvira@example.com', @uid);
call bindAccountAndRole(@uid, 'ROLE_USER');
call bindAccountAndRole(@uid, 'ROLE_STUDENT');
call bindAccountAndRole(@uid, 'ROLE_FACULTY');

call createAccount('juan', 'Juan', 'Cazares', 'juan@example.com', @uid);
call bindAccountAndRole(@uid, 'ROLE_USER');
call bindAccountAndRole(@uid, 'ROLE_ADMIN');


-- =====================================================================================================================
-- Create forums and messages
-- =====================================================================================================================

call createForum('Algebra I', 'julia', @fid);
call createMessage(@fid, 'julia', '2012-09-28 12:34:03', 'What *is* a variable?');
call createMessage(@fid, 'juan', '2012-09-30 12:34:19', 'This class is too hard');
call createMessage(@fid, 'julia', '2012-10-01 14:05:21', 'Curses, Descartes');

call createForum('Algebra II/Trigonometry', 'julia', @fid);
call createMessage(@fid, 'elvira', '2012-09-29 04:01:39', 'now i know how tall that pyramid is');
call createMessage(@fid, 'paula', '2012-09-30 16:04:11', 'When will I ever use this??');
call createMessage(@fid, 'elvira', '2012-09-30 14:30:21', 'buy v1@gRA 0nL1n3!');
update message set visible = 0 where id = last_insert_id();
call createMessage(@fid, 'daniel', '2012-10-01 19:37:00', 'Solving system of linear equations');
call createMessage(@fid, 'daniel', '2012-10-01 21:58:42', 'Need help applying Gaussian elimination');

call createForum('Precalculus', 'julia', @fid);
call createMessage(@fid, 'julia', '2012-09-27 16:32:09', 'formula for computing the volume of a sphere');
call createMessage(@fid, 'juan', '2012-10-01 17:48:02', 'Isn''t a 96-gon basically the same as a circle');
call createMessage(@fid, 'julia', '2012-10-01 17:53:36', 'Join my precalc Facebook group');

call createForum('Calculus I', 'elvira', @fid);

call createForum('Calculus II', 'elvira', @fid);
call createMessage(@fid, 'elvira', '2012-09-27 12:34:56', 'Relationship between differentiation and integration');
call createMessage(@fid, 'daniel', '2012-09-30 12:43:45', 'Integrating a volume');
call createMessage(@fid, 'paula', '2012-10-01 08:23:02', 'epsilon-delta definition of a limit');
call createMessage(@fid, 'julia', '2012-10-01 09:56:39', 'Newton or Leibniz');
call createMessage(@fid, 'julia', '2012-10-01 11:02:01', 'Help!!! Too many integration rules');

call createForum('Model theory of second-order intuitionistic modal logics', 'elvira', @fid);
call createMessage(@fid, 'elvira', '2012-09-23 14:29:06', 'Possible worlds semantics');
call createMessage(@fid, 'daniel', '2012-09-28 14:31:22', 'Kripke on naming and necessity');
call createMessage(@fid, 'julia', '2012-09-30 16:17:16', 'Nonconstructive proof that P != NP. Is it good enough??');
call createMessage(@fid, 'paula', '2012-09-30 19:43:53', 'Who is Archimedes Plutonium?');
