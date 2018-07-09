-- jopez@galileo.edu
-- cesarhj@galileo.edu
create table evaluation_grades 
(
        grade_id        integer constraint evaluation_grades_id_pk
                                primary key
                                constraint evaluation_grades_id_fk
                                references cr_revisions(revision_id),
        grade_item_id   integer constraint evaluation_grades_gid_fk
                                references cr_items(item_id),
        grade_name      varchar(100),
        grade_plural_name varchar(100),
        comments        varchar(4000),
        -- percentage of this grade type in the class
        weight          number(9,4) constraint evaluation_grades_w_ck
                                check (weight between 0 and 100)
);

create index eva_grades_gid_index on evaluation_grades(grade_item_id);

create table evaluation_tasks (
        task_id         	integer constraint evaluation_tasks_pk
                                	primary key
                                	constraint evaluation_tasks_fk
                                	references cr_revisions(revision_id),
        task_item_id    	integer constraint evaluation_tasks_tid_fk
                                	references cr_items(item_id),
        task_name       	varchar(200) constraint evaluation_tasks_tn_nn
                                	not null,
        -- we need to know if the task is in groups or not
        number_of_members       integer default 1
					constraint evaluation_tasks_nom_nn
                                        not null,
        due_date            date,
        grade_item_id   	integer constraint evaluation_tasks_gid_fk
                                	references cr_items(item_id),
        -- percentage of the grade of the course
        weight                  number(9,4),
        -- the task will be submitted on line
        online_p    		char(1) constraint      evaluation_tasks_onp_ck
                                	check(online_p in ('t','f')),
        -- will the students be able to submit late their answers?
        late_submit_p   	char(1) constraint evaluations_tasks_lsp_ck
                                        check(late_submit_p in ('t','f')),
        requires_grade_p 	char(1) constraint evaluations_tasks_rgp_ck
                                        check(requires_grade_p in ('t','f'))
);

create index eva_tasks_gid_index on evaluation_tasks(grade_item_id);
create index eva_tasks_tiid_index on evaluation_tasks(task_item_id);

create table evaluation_tasks_sols 
(
        solution_id     integer primary key,
        solution_item_id        integer
                                constraint evaluation_tsols_siid_fk
                                references cr_items(item_id),
        task_item_id    integer constraint evaluation_tsols_tid_fk
                                references cr_items(item_id)
);

-- create indexes
create index eva_tasks_sols_tid_index on evaluation_tasks_sols(task_item_id);

create table evaluation_answers 
(
        answer_id       integer primary key
                                references cr_revisions,
        answer_item_id  integer constraint evaluation_sans_aiid_fk
                                references cr_items(item_id),
        -- person/group to which the answer belongs
        party_id        integer constraint evaluation_sans_pid_nn
                                not null
                                constraint evaluation_sans_pid_fk
                                references parties(party_id),
        task_item_id    integer constraint evaluation_sans_tid_fk
                                references cr_items(item_id),
        comments        varchar(4000)
);

create index eva_answers_tid_index on evaluation_answers(party_id,task_item_id);
             
create table evaluation_student_evals 
(
        evaluation_id   	integer constraint evaluation_stu_evals_pk
                                        primary key
                                        constraint evaluation_stu_evals_fk
                                        references acs_objects(object_id),
        evaluation_item_id 	integer constraint evaluation_stu_evals_eiid
                                        references cr_items(item_id),
        task_item_id            integer constraint evaluation_stu_evals_tid_nn
                                        not null
                                        constraint evaluation_stu_evals_tid_fk
                                        references cr_items(item_id),
        -- must have student_id or team_id
        party_id                integer constraint evaluation_stu_evals_pid_nn
                                        not null
                                        constraint evaluation_stu_evals_pid_fk
                                        references parties(party_id),
        grade                   number(9,4),
        show_student_p  	char(1) default 't'
                                        constraint evaluation_stu_evals_ssp_ck
                                        check (show_student_p in ('t','f'))
);

create index eva_student_evals_tid_index on evaluation_student_evals(task_item_id);
create index eva_student_evals_pid_index on evaluation_student_evals(party_id);

-- table to store the csv sheet grades associated with the evaluations
create table evaluation_grades_sheets 
(
     grades_sheet_id         integer     primary key,
     grades_sheet_item_id    integer     constraint evaluation_gsheets_giid_fk
                                         references cr_items(item_id),
     task_item_id            integer     constraint evaluation_gsheets_t_id_fk
                                         references cr_items(item_id)
);

-- create indexes
create index eva_grades_sheets_tid_index on evaluation_grades_sheets(task_item_id);

begin
   acs_object_type.create_type(
     supertype            => 'acs_object',
     object_type          => 'evaluation_task_groups',
     pretty_name          => 'Task Group',
     pretty_plural        => 'Tasks Groups',
     table_name           => 'evaluation_task_groups',
     id_column            => 'group_id',
     package_name         => null
   );
end;
/

-- creating group_type and the table where we are going to store the information about evaluation groups for tasks in groups

create table evaluation_task_groups 
(
        group_id                integer constraint ev_task_groups_pk
                                        primary key
                                        constraint ev_task_groups_fk
                                        references groups(group_id),
        task_item_id            integer constraint ev_task_groups_tid_nn
                                        not null
                                        constraint ev_task_groups_tid_fk
                                        references cr_items(item_id)
);

create index eva_task_groups_tid_index on evaluation_task_groups(task_item_id);

insert into group_types (group_type) values ('evaluation_task_groups');

insert into acs_object_type_tables
    (object_type, table_name, id_column)
    values
    ('evaluation_task_groups', 'evaluation_task_groups', 'group_id');

-- task_id used to be a column in evaluation_task_groups and was then
-- renamed to task_item_id. Attribute was not updated accordingly and
-- is most likely useless now. Left here for documentation.
-- declare
--     attr_id acs_attributes.attribute_id%TYPE;
-- begin
--     attr_id := acs_attribute.create_attribute
--    (
--     object_type     => 'evaluation_task_groups',       
--     attribute_name  => 'task_id',                      
--     datatype        => 'integer',                      
--     pretty_name     => 'Task id',                      
--     pretty_plural   => 'Task ids',                     
--     table_name      => 'evaluation_task_groups',       
--     column_name     => 'task_id',                              
--     min_n_values    => 1,                                      
--     max_n_values    => 1,                                      
--     storage         => 'type_specific'                        
--     );
-- end;
/

create table evaluation_user_profile_rels 
(
    rel_id  integer constraint ev_user_profile_rels_pk
            primary key
);


begin
    acs_rel_type.create_type
    (
      rel_type        => 'evaluation_task_group_rel',
      pretty_name     => 'Evaluation Task Group Member',
      pretty_plural   => 'Evaluation Task Group Members',
      supertype       => 'membership_rel',
      table_name      => 'evaluation_user_profile_rels',
      id_column       => 'rel_id',
      package_name    => 'evaluation',
      object_type_one => 'evaluation_task_groups',
      role_one        => null,
      min_n_rels_one  => 0,
      max_n_rels_one  => null,
      object_type_two => 'user',
      role_two        => null,
      min_n_rels_two  => 0,
      max_n_rels_two  => 1
    );
end;
/
show errors;

@ evaluation-package-create.sql

@ evaluation-calendar-create.sql

