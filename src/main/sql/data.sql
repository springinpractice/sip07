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

insert into forum (id, owner_id, name) values
    (100, 3, 'Algebra I'),
    (101, 3, 'Algebra II/Trigonometry'),
    (102, 3, 'Precalculus'),
    (103, 4, 'Calculus I'),
    (104, 4, 'Calculus II'),
    (105, 4, 'Model theory of second-order intuitionistic modal logics');

call createMessage(100, 3, 1, '2012-09-28 12:34:03', 'What *is* a variable?');
call createMessage(100, 5, 1, '2012-09-30 12:34:19', 'This class is too hard');
call createMessage(100, 3, 1, '2012-10-01 14:05:21', 'Curses, Descartes');
call createMessage(101, 4, 1, '2012-09-29 04:01:39', 'now i know how tall that pyramid is');
call createMessage(101, 1, 1, '2012-09-30 16:04:11', 'When will I ever use this??');
call createMessage(101, 4, 0, '2012-09-30 14:30:21', 'buy v1@gRA 0nL1n3!');
call createMessage(101, 2, 1, '2012-10-01 19:37:00', 'Solving system of linear equations');
call createMessage(101, 2, 1, '2012-10-01 21:58:42', 'Need help applying Gaussian elimination');
call createMessage(102, 3, 1, '2012-09-27 16:32:09', 'formula for computing the volume of a sphere');
call createMessage(102, 5, 1, '2012-10-01 17:48:02', 'Isn''t a 96-gon basically the same as a circle');
call createMessage(102, 3, 1, '2012-10-01 17:53:36', 'Join my precalc Facebook group');
call createMessage(104, 4, 1, '2012-09-27 12:34:56', 'Relationship between differentiation and integration');
call createMessage(104, 2, 1, '2012-09-30 12:43:45', 'Integrating a volume');
call createMessage(104, 1, 1, '2012-10-01 08:23:02', 'epsilon-delta definition of a limit');
call createMessage(104, 3, 1, '2012-10-01 09:56:39', 'Newton or Leibniz');
call createMessage(104, 3, 1, '2012-10-01 11:02:01', 'Help!!! Too many integration rules');
call createMessage(105, 4, 1, '2012-09-23 14:29:06', 'Possible worlds semantics');
call createMessage(105, 2, 1, '2012-09-28 14:31:22', 'Kripke on naming and necessity');
call createMessage(105, 3, 1, '2012-09-30 16:17:16', 'Nonconstructive proof that P != NP. Is it good enough??');
call createMessage(105, 1, 1, '2012-09-30 19:43:53', 'Who is Archimedes Plutonium?');


-- =====================================================================================================================
-- The following records are for the ACL schema.
-- =====================================================================================================================

-- Security IDs: an abstraction over roles and principals representing the "who" piece of the ACL check.
insert into acl_sid (id, principal, sid) values
    (100, 0, "ROLE_USER"),
    (101, 0, "ROLE_ADMIN"),
    (200, 1, "paula"),
    (201, 1, "daniel"),
    (202, 1, "julia"),
    (203, 1, "elvira"),
    (204, 1, "juan");

-- Defines the domain object types. This is part of the "what" check. We have a site, forums and messages.
insert into acl_class (id, class) values
    (1, "java.lang.Object"),
    (2, "com.springinpractice.ch07.domain.Forum"),
    (3, "com.springinpractice.ch07.domain.Message");

-- Site. This is the other part of the "what" check.
insert into acl_object_identity (id, object_id_class, object_id_identity, parent_object, owner_sid, entries_inheriting) values
    (1, 1, 1, null, 101, 0);

-- Forums and messages. This is also part of the "what" check.
insert into acl_object_identity (id, object_id_class, object_id_identity, parent_object, owner_sid) values
    
    -- Forum moderators
    (100, 2, 100, 1, 202), -- Algebra I forum, moderated by julia
    (101, 2, 101, 1, 202), -- Algebra II/Trig forum, moderated by julia
    (102, 2, 102, 1, 202), -- Precalc forum, moderated by julia
    (103, 2, 103, 1, 203), -- Calc I forum, moderated by elvira
    (104, 2, 104, 1, 203), -- Calc II forum, moderated by elvira
    (105, 2, 105, 1, 203), -- Modal Logic forum, moderated by elvira
    
    -- Message owners
    (106, 3, 100, 100, 202), -- Algebra I messages (parent is forum 100)
    (107, 3, 101, 100, 204),
    (108, 3, 102, 100, 202),
    (109, 3, 103, 101, 203), -- Algebra II/Trig messages (parent is forum 101)
    (110, 3, 104, 101, 200),
    (111, 3, 105, 101, 203), -- spam
    (112, 3, 106, 101, 201),
    (113, 3, 107, 101, 201),
    (114, 3, 108, 102, 202), -- Precalc messages (parent is forum 102)
    (115, 3, 109, 102, 204),
    (116, 3, 110, 102, 202),
    (117, 3, 111, 104, 203), -- Calc II messages (parent is forum 104)
    (118, 3, 112, 104, 201),
    (119, 3, 113, 104, 200),
    (120, 3, 114, 104, 202),
    (121, 3, 115, 104, 202),
    (122, 3, 116, 105, 203), -- Modal Logic messages (parent is forum 105)
    (123, 3, 117, 105, 201),
    (124, 3, 118, 105, 202),
    (125, 3, 119, 105, 200);

-- ACL entries. These specify who has which permission on which object.
-- Bitwise permission mask semantics: read (bit 0), write (bit 1), create (bit 2), delete (bit 3), admin (bit 4).
-- WARNING: The "mask" isn't really a mask at all as you can set only one bit at a time! See
-- http://jira.springframework.org/browse/SEC-1140
insert into acl_entry (acl_object_identity, ace_order, sid, mask) values 
    (1, 0, 100, 1), -- ROLE_USER has read for site
    (1, 1, 101, 1), -- ROLE_ADMIN has read for site
    (1, 2, 101, 2), -- ROLE_ADMIN has write for site
    (1, 3, 101, 4), -- ROLE_ADMIN has create for site
    (1, 4, 101, 8), -- ROLE_ADMIN has delete for site
    (1, 5, 101, 16), -- ROLE_ADMIN has admin for site
    
    (100, 0, 202, 1), -- julia has read for Algebra I
    (100, 1, 202, 2), -- julia has write for Algebra I
    (100, 2, 202, 4), -- julia has create for Algebra I
    (100, 3, 202, 8), -- julia has delete for Algebra I
    (100, 4, 202, 16), -- julia has admin for Algebra I
    (101, 0, 202, 1), -- julia has read for Algebra II
    (101, 1, 202, 2), -- julia has write for Algebra II
    (101, 2, 202, 4), -- julia has create for Algebra II
    (101, 3, 202, 8), -- julia has delete for Algebra II
    (101, 4, 202, 16), -- julia has admin for Algebra II
    (102, 0, 202, 1), -- julia has read for Precalc
    (102, 1, 202, 2), -- julia has write for Precalc
    (102, 2, 202, 4), -- julia has create for Precalc
    (102, 3, 202, 8), -- julia has delete for Precalc
    (102, 4, 202, 16), -- julia has admin for Precalc
    (103, 0, 203, 1), -- elvira has read for Calc I
    (103, 1, 203, 2), -- elvira has write for Calc I
    (103, 2, 203, 4), -- elvira has create for Calc I
    (103, 3, 203, 8), -- elvira has delete for Calc I
    (103, 4, 203, 16), -- elvira has admin for Calc I
    (104, 0, 203, 1), -- elvira has read for Calc II
    (104, 1, 203, 2), -- elvira has write for Calc II
    (104, 2, 203, 4), -- elvira has create for Calc II
    (104, 3, 203, 8), -- elvira has delete for Calc II
    (104, 4, 203, 16), -- elvira has admin for Calc II
    (105, 0, 203, 1), -- elvira has read for Modal Logic
    (105, 1, 203, 2), -- elvira has write for Modal Logic
    (105, 2, 203, 4), -- elvira has create for Modal Logic
    (105, 3, 203, 8), -- elvira has delete for Modal Logic
    (105, 4, 203, 16), -- elvira has admin for Modal Logic
    
    (106, 0, 202, 2), -- julia has write access (Algebra I message)
    (107, 0, 204, 2), -- juan has write access (Algebra I message)
    (108, 0, 202, 2), -- julia has write access (Algebra I message)
    (109, 0, 203, 2), -- elvira has write access (Algebra II/Trig message)
    (110, 0, 200, 2), -- paula has write access (Algebra II/Trig message)
    (112, 0, 201, 2), -- daniel has write access (Algebra II/Trig message)
    (113, 0, 201, 2), -- daniel has write access (Algebra II/Trig message)
    (114, 0, 202, 2), -- julia has write access (Precalc message)
    (115, 0, 204, 2), -- juan has write access (Precalc message)
    (116, 0, 202, 2), -- julia has write access (Precalc message)
    (117, 0, 203, 2), -- elvira has write access (Calc II message)
    (118, 0, 201, 2), -- daniel has write access (Calc II message)
    (119, 0, 200, 2), -- paula has write access (Calc II message)
    (120, 0, 202, 2), -- julia has write access (Calc II message)
    (121, 0, 202, 2), -- julia has write access (Calc II message)
    (122, 0, 203, 2), -- elvira has write access (Modal Logic message)
    (123, 0, 201, 2), -- daniel has write access (Modal Logic message)
    (124, 0, 202, 2), -- julia has write access (Modal Logic message)
    (125, 0, 200, 2); -- paula has write access (Modal Logic message)
