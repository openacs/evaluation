-- jopez@galileo.edu
-- cesarhj@galileo.edu
create table evaluation_grades (
	grade_id	integer
				constraint evaluation_grades_id_pk
				primary key
				constraint evaluation_grades_id_fk
				references cr_revisions(revision_id),
	grade_item_id	integer
				constraint evaluation_grades_gid_fk
				references cr_items(item_id),
	grade_name	varchar(100),
	grade_plural_name varchar(100),
	comments 	text,	
	-- percentage of this grade type in the class
	weight		numeric
				constraint evaluation_grades_w_ck
				check (weight between 0 and 100)
);

create index evalutaion_grades_giid_index on evaluation_grades(grade_item_id);

create table evaluation_tasks (
	task_id		integer
				constraint evaluation_tasks_pk
				primary key
				constraint evaluation_tasks_fk
				references cr_revisions(revision_id),
	task_item_id	integer
				constraint evaluation_tasks_tid_fk
				references cr_items(item_id),
	task_name   varchar
		   		constraint evaluation_tasks_tn_nn
		   		not null,
	-- we need to know if the task is in groups or not
	number_of_members	integer
						constraint evaluation_tasks_nom_nn
						not null
						constraint evaluation_tasks_nom_df
						default 1,
	due_date	timestamp,
	grade_item_id	integer
				constraint evaluation_tasks_gid_fk
				references cr_items(item_id),
	-- percentage of the grade of the course
	weight		numeric,
	-- the task will be submitted on line
	online_p        boolean,
	-- will the students be able to submit late their answers?
	late_submit_p	 boolean,
	requires_grade_p boolean,
	-- estimated time to complete the assignment
	estimated_time	 decimal,
	points 		 numeric,
	perfect_score	 numeric,
	relative_weight  numeric,
	forums_related_p boolean
);

create index evalutaion_tasks_gid_index on evaluation_tasks(grade_item_id);
create index evalutaion_tasks_tiid_index on evaluation_tasks(task_item_id);

create table evaluation_tasks_sols (
	solution_id	integer
				primary key,
	solution_item_id	integer
				constraint evaluation_tsols_siid_fk
				references cr_items(item_id),
	task_item_id    integer
				constraint evaluation_tsols_tid_fk
				references cr_items(item_id)
);

-- create indexes
create index evalutaion_tasks_sols_tid_index on evaluation_tasks_sols(task_item_id);

create table evaluation_answers (
	answer_id	integer
				primary key
				references cr_revisions,
	answer_item_id	integer
				constraint evaluation_sans_aiid_fk
				references cr_items(item_id),
	-- person/group to which the answer belongs
	party_id    integer
				constraint evaluation_sans_pid_nn
				not null
				constraint evaluation_sans_pid_fk
				references parties(party_id),
	task_item_id     integer
				constraint evaluation_sans_tid_fk
				references cr_items(item_id),
	comment 	 text
);

create index evaluation_answers_tid_index on evaluation_answers(party_id,task_item_id);
create table evaluation_student_evals (
	evaluation_id	integer
					constraint evaluation_stu_evals_pk
					primary key
					constraint evaluation_stu_evals_fk
					references acs_objects(object_id),
	evaluation_item_id integer	constraint evaluation_stu_evals_eiid
					references cr_items(item_id),
	task_item_id	integer
					constraint evaluation_stu_evals_tid_nn
					not null
					constraint evaluation_stu_evals_tid_fk
					references cr_items(item_id),
	-- must have student_id or team_id
	party_id		integer
					constraint evaluation_stu_evals_pid_nn
					not null
					constraint evaluation_stu_evals_pid_fk
					references parties(party_id),
	grade			numeric,
	show_student_p	        boolean
					constraint evaluation_stu_evals_ssp_df
					default true
);

create index evaluation_student_evals_tid_index on evaluation_student_evals(task_item_id);
create index evaluation_student_evals_pid_index on evaluation_student_evals(party_id);

-- table to store the csv sheet grades associated with the evaluations
create table evaluation_grades_sheets (
	grades_sheet_id	 	integer
				 		primary key,
	grades_sheet_item_id 	integer
						constraint evaluation_gsheets_giid_fk
						references cr_items(item_id),
	task_item_id		integer
				 		constraint evaluation_gsheets_t_id_fk
				 		references cr_items(item_id)
);

-- create indexes
create index evalutaion_grades_sheets_tid_index on evaluation_grades_sheets(task_item_id);

select acs_object_type__create_type (
    'evaluation_task_groups', 	--object type
    'Task Group',   			--pretty name
    'Tasks Groups',  			--pretty prural
    'acs_object',  				--supertype
    'evaluation_task_groups',  	--table_name
    'group_id',  	  			--id_column
    null,  						--package_name
    'f',  						--abstract_p
    null,  						--type_extension_table
    null  						--name_method
);

-- creating group_type and the table where we are going to store the information about evaluation groups for tasks in groups

create table evaluation_task_groups (
	group_id  		integer
					constraint evaluation_task_groups_pk
					primary key
  					constraint evaluation_task_groups_fk
  					references groups(group_id),
	task_item_id	  		integer
			  		constraint evaluation_task_groups_tid_nn
		  			not null
	  				constraint evaluation_task_groups_tid_fk
		   			references cr_items(item_id)
);

create index evaluation_task_groups_tid_index on evaluation_task_groups(task_item_id);

insert into group_types (group_type) values ('evaluation_task_groups');

insert into acs_object_type_tables
    (object_type, table_name, id_column)
    values
    ('evaluation_task_groups', 'evaluation_task_groups', 'group_id');

-- task_id used to be a column in evaluation_task_groups and was then
-- renamed to task_item_id. Attribute was not updated accordingly and
-- is most likely useless now. Left here for documentation.
-- select acs_attribute__create_attribute (	
-- 	'evaluation_task_groups', 	--object_type
-- 	'task_id', 					--oattribute_name
-- 	'integer', 					--datatype
-- 	'Task id', 					--pretty_name
-- 	'Task ids', 				--pretty_plural
-- 	'evaluation_task_groups', 	--table_name
-- 	'task_id',				 	--column_name
-- 	null,						--default_value
-- 	1, 						--min_n_values
-- 	1, 						--max_n_values
-- 	null, 						--sort_order
-- 	'type_specific', 			--storage
-- 	'f' 						--static_p
-- );

create table evaluation_user_profile_rels (
    rel_id                      integer
                                constraint evaluation_user_profile_rels_pk
                                primary key
);

select acs_rel_type__create_type(
        'evaluation_task_group_rel',
        'Evaluation Task Group Member',
        'Evaluation Task Group Members',
		'membership_rel',
        'evaluation_user_profile_rels',
        'rel_id',
        'evaluations',
        'evaluation_task_groups',
        null,
        0,
        null::integer,
        'user',
        null,
        0,
        1
);

\i evaluation-package-create.sql                                                                                                                                                
\i evaluation-calendar-create.sql
