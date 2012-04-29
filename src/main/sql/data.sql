-- Create permissions

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


-- Create roles

call createRole('ROLE_USER', @role_user);
call roleHasPermission(@role_user, 'PERM_READ_ACCOUNTS');
call roleHasPermission(@role_user, 'PERM_READ_FORUMS');
call roleHasPermission(@role_user, 'PERM_CREATE_MESSAGES');
call roleHasPermission(@role_user, 'PERM_READ_MESSAGES');

call createRole('ROLE_ADMIN', @role_admin);
call roleHasPermission(@role_admin, 'PERM_UPDATE_MESSAGES');
call roleHasPermission(@role_admin, 'PERM_DELETE_MESSAGES');
call roleHasPermission(@role_admin, 'PERM_ADMIN_MESSAGES');

call createRole('ROLE_STUDENT', @role_student);
call createRole('ROLE_FACULTY', @role_faculty);


-- Create accounts

call createAccount('paula', 'Paula', 'Cazares', 'paula@example.com', @paula);
call accountHasRole(@paula, @role_user);

call createAccount('daniel', 'Daniel', 'Cazares', 'daniel@example.com', @daniel);
call accountHasRole(@daniel, @role_user);
call accountHasRole(@daniel, @role_student);

call createAccount('julia', 'Julia', 'Cazares', 'julia@example.com', @julia);
call accountHasRole(@julia, @role_user);
call accountHasRole(@julia, @role_faculty);

call createAccount('elvira', 'Elvira', 'Cazares', 'elvira@example.com', @elvira);
call accountHasRole(@elvira, @role_user);
call accountHasRole(@elvira, @role_student);
call accountHasRole(@elvira, @role_faculty);

call createAccount('juan', 'Juan', 'Cazares', 'juan@example.com', @juan);
call accountHasRole(@juan, @role_user);
call accountHasRole(@juan, @role_admin);


-- Create site, forums and messages

call createAclClass('java.lang.Object', @site_class);
call createAclClass('com.springinpractice.ch07.domain.Forum', @forum_class);
call createAclClass('com.springinpractice.ch07.domain.Message', @message_class);

call createSite(@site_oid);

call createForum('Algebra I', @julia, @forum);
call createMessage(@forum, @julia, '2012-09-28 12:34:03', 'What *is* a variable?');
call createMessage(@forum, @juan, '2012-09-30 12:34:19', 'This class is too hard');
call createMessage(@forum, @julia, '2012-10-01 14:05:21', 'Curses, Descartes');

call createForum('Algebra II/Trigonometry', @julia, @forum);
call createMessage(@forum, @elvira, '2012-09-29 04:01:39', 'now i know how tall that pyramid is');
call createMessage(@forum, @paula, '2012-09-30 16:04:11', 'When will I ever use this??');
call createMessage(@forum, @elvira, '2012-09-30 14:30:21', 'buy v1@gRA 0nL1n3!');
update message set visible = 0 where id = last_insert_id();
call createMessage(@forum, @daniel, '2012-10-01 19:37:00', 'Solving system of linear equations');
call createMessage(@forum, @daniel, '2012-10-01 21:58:42', 'Need help applying Gaussian elimination');

call createForum('Precalculus', @julia, @forum);
call createMessage(@forum, @julia, '2012-09-27 16:32:09', 'formula for computing the volume of a sphere');
call createMessage(@forum, @juan, '2012-10-01 17:48:02', 'Isn''t a 96-gon basically the same as a circle');
call createMessage(@forum, @julia, '2012-10-01 17:53:36', 'Join my precalc Facebook group');

call createForum('Calculus I', @elvira, @forum);

call createForum('Calculus II', @elvira, @forum);
call createMessage(@forum, @elvira, '2012-09-27 12:34:56', 'Relationship between differentiation and integration');
call createMessage(@forum, @daniel, '2012-09-30 12:43:45', 'Integrating a volume');
call createMessage(@forum, @paula, '2012-10-01 08:23:02', 'epsilon-delta definition of a limit');
call createMessage(@forum, @julia, '2012-10-01 09:56:39', 'Newton or Leibniz');
call createMessage(@forum, @julia, '2012-10-01 11:02:01', 'Help!!! Too many integration rules');

call createForum('Model theory of second-order intuitionistic modal logics', @elvira, @forum);
call createMessage(@forum, @elvira, '2012-09-23 14:29:06', 'Possible worlds semantics');
call createMessage(@forum, @daniel, '2012-09-28 14:31:22', 'Kripke on naming and necessity');
call createMessage(@forum, @julia, '2012-09-30 16:17:16', 'Nonconstructive proof that P != NP. Is it good enough??');
call createMessage(@forum, @paula, '2012-09-30 19:43:53', 'Who is Archimedes Plutonium?');
