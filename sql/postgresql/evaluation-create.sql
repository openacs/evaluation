-- jopez@galileo.edu

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
	comments	text,
	-- percentage of this grade type in the class
	weight		numeric
				constraint evaluation_grades_w_ck
				check (weight between 0 and 100)
);

create index evalutaion_grades_giid_index on evaluation_grades(grade_item_id);

select content_type__create_type (
	'evaluation_grades',			-- content_type
	'content_revision',			-- super_type
	'Evaluation Grade',			-- pretty_name
	'Evaluation Grades',			-- pretty_plural
	'evaluation_grades',			-- table_name
	'grade_id',					-- id_column
	null		-- name_method
);

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
	online_p    char(1)
				constraint	evaluation_tasks_onp_ck
				check(online_p in ('t','f')),
	-- will the students be able to submit late their answers?
	late_submit_p	char(1)
					constraint evaluations_tasks_lsp_ck
					check(late_submit_p in ('t','f')),
	requires_grade_p char(1)
					constraint evaluations_tasks_rgp_ck
					check(late_submit_p in ('t','f')),
	-- estimated time to complete the assigment
	estimated_time	decimal	
);

create index evalutaion_tasks_gid_index on evaluation_tasks(grade_item_id);
create index evalutaion_tasks_tiid_index on evaluation_tasks(task_item_id);

select content_type__create_type (
	'evaluation_tasks',			-- content_type
	'content_revision',			-- super_type
	'Evaluation Task',			-- pretty_name
	'Evaluation Tasks',			-- pretty_plural
	'evaluation_tasks',			-- table_name
	'task_id',					-- id_column
	null		-- name_method
);

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

select content_type__create_type (
	'evaluation_tasks_sols',			-- content_type
	'content_revision',			-- super_type
	'Evaluation Task Solution',			-- pretty_name
	'Evaluation Tasks Solutions',			-- pretty_plural
	'evaluation_tasks_sols',			-- table_name
	'solution_id',					-- id_column
	null		-- name_method
);

create table evaluation_answers (
	answer_id	integer
				primary key
				references cr_revisions,
	answer_item_id	integer
				constraint evaluation_sans_aiid_fk
				references cr_items(item_id),
	-- person/group to wich the answer belongs
	party_id    integer
				constraint evaluation_sans_pid_nn
				not null
				constraint evaluation_sans_pid_fk
				references parties(party_id),
	task_item_id     integer
				constraint evaluation_sans_tid_fk
				references cr_items(item_id)
);

create index evaluation_answers_tid_index on evaluation_answers(party_id,task_item_id);

select content_type__create_type (
	'evaluation_answers',			-- content_type
	'content_revision',			-- super_type
	'Student Answer',			-- pretty_name
	'Student Answers',			-- pretty_plural
	'evaluation_answers',			-- table_name
	'answer_id',					-- id_column
	null		-- name_method
);


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
	show_student_p	char(1)
					constraint evaluation_stu_evals_ssp_df
					default 't'
					constraint evaluation_stu_evals_ssp_ck
					check (show_student_p in ('t','f'))
);

create index evaluation_student_evals_tid_index on evaluation_student_evals(task_item_id);
create index evaluation_student_evals_pid_index on evaluation_student_evals(party_id);

select content_type__create_type (
	'evaluation_student_evals',			-- content_type
	'content_revision',			-- super_type
	'Student Evaluation',			-- pretty_name
	'Student Evaluations',			-- pretty_plural
	'evaluation_student_evals',			-- table_name
	'evaluation_id',					-- id_column
	null		-- name_method
);

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

select content_type__create_type (
	'evaluation_grades_sheets',			-- content_type
	'content_revision',		 			-- super_type
	'Evaluation Grades Sheet',			-- pretty_name
	'Evaluation Grades Sheets',			-- pretty_plural
	'evaluation_grades_sheets',			-- table_name
	'grades_sheet_id',					-- id_column
	null		 	 	  				-- name_method
);


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

select acs_attribute__create_attribute (	
	'evaluation_task_groups', 	--object_type
	'task_id', 					--oattribute_name
	'integer', 					--datatype
	'Task id', 					--pretty_name
	'Task ids', 				--pretty_plural
	'evaluation_task_groups', 	--table_name
	'task_id',				 	--column_name
	null,						--default_value
	1, 						--min_n_values
	1, 						--max_n_values
	null, 						--sort_order
	'type_specific', 			--storage
	'f' 						--static_p
);

create function evaluation__new_item (integer,varchar,varchar,integer,integer,timestamptz,varchar,varchar,text,varchar,varchar,text,varchar,varchar,varchar)
returns integer as '
declare
	p_item_id    		alias for $1;
	p_name				alias for $2;
	p_locale			alias for $3;
	p_creation_user		alias for $4;
	p_package_id		alias for $5;
	p_creation_date	   	alias for $6;
	p_creation_ip		alias for $7;
	p_title				alias for $8;
	p_description		alias for $9;
	p_mime_type			alias for $10;
	p_nls_language		alias for $11;
	p_text		    	alias for $12;
	p_storage_type	    alias for $13;
	p_item_subtype  	alias for $14;
	p_content_type	    alias for $15;

	v_item_id		integer;
	v_parent_id		integer;
	v_id			integer;
begin

    select content_item__get_id(p_content_type||''_''||p_package_id,null,''f'')
    into   v_parent_id 
    from   dual;    
    --
    -- this will be used for 2xClick protection
 if p_item_id is null then
        select acs_object_id_seq.nextval 
        into   v_id 
        from   dual;
    else 
        v_id := p_item_id;
    end if; 

    select coalesce((select content_item__new(
        p_name,               -- name
        v_parent_id,          -- parent_id
        v_id,                 -- item_id
        p_locale,             -- locale
        p_creation_date,    -- creation_date
        p_creation_user,      -- creation_user
		p_package_id,         -- context_id
        p_creation_ip,        -- creation_ip
        p_item_subtype,     -- item_subtype
        p_content_type,             -- content_type
		p_title,                 -- title
		p_description,                 -- description
        p_mime_type,          -- mime_type
        p_nls_language,       -- nls_language
	    p_text,				  -- text
		p_storage_type  			  -- storage_type
    ) where not exists (select 1 from cr_items where item_id = v_id)),0) into v_item_id;

	return v_item_id;
end;
' language 'plpgsql';

---------------------------------------
-- GRADES
---------------------------------------

create function evaluation__new_grade (integer, integer, varchar, varchar, numeric, varchar, timestamptz, integer, varchar, varchar, varchar, timestamptz, varchar, varchar)
returns integer as '
declare
	p_item_id			alias for $1;
	p_revision_id		alias for $2;
	p_grade_name 		alias for $3;
	p_grade_plural_name  	alias for $4;
	p_weight			alias for $5;
	p_object_type		alias for $6;
	p_creation_date		alias for $7;
	p_creation_user 	alias for $8;
	p_creation_ip		alias for $9;
	p_title				alias for $10; -- default null
	p_description		alias for $11; -- default null
	p_publish_date		alias for $12;
	p_nls_language   	alias for $13; -- default null
	p_mime_type   		alias for $14; -- default null

	v_revision_id		integer;

begin

    v_revision_id := content_revision__new(
        p_title,               	-- title
		p_description,			-- description
		p_publish_date,			-- publish_date
		p_mime_type,			-- mime_type
		p_nls_language,			-- nls_language
		null,					-- data
		p_item_id,				-- item_id
		p_revision_id,			-- revision_id
		p_creation_date,		-- creation_date
		p_creation_user,		-- creation_user
		p_creation_ip,			-- creation_ip
	    null				    -- content length
    );

	insert into evaluation_grades
			(grade_id,
			grade_item_id, 
			grade_name,
			grade_plural_name, 
			comments, 
			weight)
	values
			(v_revision_id,
			p_item_id, 
			p_grade_name, 
			p_grade_plural_name,
			p_description,
			p_weight);

	return v_revision_id;
end;
' language 'plpgsql';

create function evaluation__delete_grade (integer)
returns integer as '
declare
	p_grade_item_id	alias for $1;
	del_rec		record;

begin
	
    FOR del_rec IN
        select task_item_id
        from  evaluation_tasks
        where grade_item_id = p_grade_item_id

    LOOP

	PERFORM evaluation__delete_student_eval(evaluation_id) from evaluation_student_evals where task_item_id = del_rec.task_item_id;
	PERFORM evaluation__delete_answer(answer_id) from evaluation_answers where task_item_id = del_rec.task_item_id;
	PERFORM evaluation__delete_task_sol(solution_id) from evaluation_tasks_sols where task_item_id = del_rec.task_item_id;
	PERFORM evaluation__delete_grades_sheet(grades_sheet_id) from evaluation_grades_sheets where task_item_id = del_rec.task_item_id;

    END LOOP;

	PERFORM evaluation__delete_task(task_id) from evaluation_tasks where grade_item_id = p_grade_item_id;
	delete from evaluation_grades where grade_item_id = p_grade_item_id;

	PERFORM  content_revision__delete(grade_id) from evaluation_grades where grade_item_id = p_grade_item_id;

	return 0;

end;' language 'plpgsql';

create function grade__name(integer)
returns varchar as '
declare 
    p_grade_id      alias for $1;
    v_grade_name    evaluation_grades.grade_name%TYPE;
begin
	select grade_name  into v_grade_name
		from evaluation_grades
		where grade_id = p_grade_id;

    return v_grade_name;
end;
' language 'plpgsql';

---------------------------------------
-- TASKS
---------------------------------------

create function evaluation__new_task (integer, integer, varchar, integer, integer, varchar, numeric, timestamptz, char, char, char, decimal, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar)
returns integer as '
declare
	p_item_id			alias for $1;
	p_revision_id		alias for $2;
	p_task_name 		alias for $3;
	p_number_of_members alias for $4;
	p_grade_item_id		alias for $5;
	p_description  		alias for $6;
	p_weight			alias for $7;
	p_due_date     	 	alias for $8;
 	p_late_submit_p  	alias for $9;
	p_online_p  		alias for $10;
	p_requires_grade_p  alias for $11;
	estimated_time		alias for $12;
	p_object_type		alias for $13;
	p_creation_date		alias for $14;
	p_creation_user 	alias for $15;
	p_creation_ip		alias for $16;
	p_title				alias for $17; -- default null
	p_publish_date		alias for $18;
	p_nls_language   	alias for $19; -- default null
	p_mime_type   		alias for $20; -- default null

	v_revision_id		integer;

begin

    v_revision_id := content_revision__new(
        p_title,               	-- title
		p_description,			-- description
		p_publish_date,			-- publish_date
		p_mime_type,			-- mime_type
		p_nls_language,			-- nls_language
		null,					-- data
		p_item_id,				-- item_id
		p_revision_id,			-- revision_id
		p_creation_date,		-- creation_date
		p_creation_user,		-- creation_user
		p_creation_ip,			-- creation_ip
	    null				    -- content length
    );

	insert into evaluation_tasks 
			(task_id,
			task_item_id,
	        task_name,
			number_of_members, 
			due_date, 	
			grade_item_id, 
			weight, 	
			online_p, 
			late_submit_p,
		    requires_grade_p)
	values
			(v_revision_id,
			p_item_id, 
	   		p_task_name,
			p_number_of_members, 
			p_due_date, 	
			p_grade_item_id, 
			p_weight, 	
			p_online_p, 
			p_late_submit_p,
			p_requires_grade_p);

	return v_revision_id;
end;
' language 'plpgsql';

create function evaluation__delete_task (integer)
returns integer as '
declare
	p_task_item_id 	alias for $1;
	del_rec	 	record;
begin
	

	PERFORM evaluation__delete_student_eval(evaluation_id) from evaluation_student_evals where task_item_id = p_task_item_id;
	PERFORM evaluation__delete_answer(answer_id) from evaluation_answers where task_item_id = p_task_item_id;
	PERFORM evaluation__delete_task_sol(solution_id) from evaluation_tasks_sols where task_item_id = p_task_item_id;
	PERFORM evaluation__delete_grades_sheet(grades_sheet_id) from evaluation_grades_sheets where task_item_id = p_task_item_id;

	delete from evaluation_tasks where task_id = p_task_item_id;
	
	PERFORM content_revision__delete(task_id) from evaluation_tasks where task_item_id = p_task_item_id;

	return 0;

end;' language 'plpgsql';

create function task__name(integer)
returns varchar as '
declare 
    p_task_id      alias for $1;
    v_task_name    evaluation_tasks.task_name%TYPE;
begin
	select task_name  into v_task_name
		from evaluation_tasks
		where task_id = p_task_id;

    return v_task_name;
end;
' language 'plpgsql';

---------------------------------------
-- TASKS SOLUTIONS
---------------------------------------

create function evaluation__new_task_sol (integer, integer, integer, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar)
returns integer as '
declare
	p_item_id			alias for $1;
	p_revision_id		alias for $2;
	p_task_item_id			alias for $3;
	p_object_type		alias for $4;
	p_creation_date		alias for $5;
	p_creation_user 	alias for $6;
	p_creation_ip		alias for $7;
	p_title				alias for $8; -- default null
	p_publish_date		alias for $9;
	p_nls_language   	alias for $10; -- default null
	p_mime_type   		alias for $11; -- default null

	v_revision_id		integer;

begin

    v_revision_id := content_revision__new(
        p_title,               	-- title
		''task solution'',	 	-- description
		p_publish_date,			-- publish_date
		p_mime_type,			-- mime_type
		p_nls_language,			-- nls_language
		null,					-- data
		p_item_id,				-- item_id
		p_revision_id,			-- revision_id
		p_creation_date,		-- creation_date
		p_creation_user,		-- creation_user
		p_creation_ip,			-- creation_ip
	    null				    -- content length
    );

	insert into evaluation_tasks_sols
			(solution_id,
			solution_item_id,
	        task_item_id)
	values
			(v_revision_id, 
			p_item_id,
	   		p_task_item_id);

	return v_revision_id;
end;
' language 'plpgsql';

create function evaluation__delete_task_sol (integer)
returns integer as '
declare
	p_solution_id 	alias for $1;
begin
	
	delete from evaluation_tasks_sols where solution_id = p_solution_id;
	
	PERFORM  content_revision__delete(p_solution_id);

	return 0;

end;' language 'plpgsql';


---------------------------------------
-- STUDENT ANSWERS
---------------------------------------


create function evaluation__new_answer (integer, integer, integer, integer, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar)
returns integer as '
declare
	p_item_id			alias for $1;
	p_revision_id		alias for $2;
	p_task_item_id		alias for $3;
    p_party_id  	   	alias for $4;	
	p_object_type		alias for $5;
	p_creation_date		alias for $6;
	p_creation_user 	alias for $7;
	p_creation_ip		alias for $8;
	p_title				alias for $9; -- default null
	p_publish_date		alias for $10;
	p_nls_language   	alias for $11; -- default null
	p_mime_type   		alias for $12; -- default null

	v_revision_id		integer;

begin

    v_revision_id := content_revision__new(
        p_title,               	-- title
		''evaluation answer'',	 	-- description
		p_publish_date,			-- publish_date
		p_mime_type,			-- mime_type
		p_nls_language,			-- nls_language
		null,					-- data
		p_item_id,				-- item_id
		p_revision_id,			-- revision_id
		p_creation_date,		-- creation_date
		p_creation_user,		-- creation_user
		p_creation_ip,			-- creation_ip
	    null				    -- content length
    );

	insert into evaluation_answers
			(answer_id,
			answer_item_id,
	        task_item_id,
	        party_id)
	values
			(v_revision_id,
			p_item_id, 
	   		p_task_item_id,
    		p_party_id);

	return v_revision_id;
end;
' language 'plpgsql';


create function evaluation__delete_answer (integer)
returns integer as '
declare
	p_answer_id 	alias for $1;
begin
	
	delete from evaluation_answers where answer_id = p_answer_id;
	
	PERFORM  content_revision__delete(p_answer_id);

	return 0;

end;' language 'plpgsql';

---------------------------------------
-- GRADES SHEETS
---------------------------------------

create function evaluation__new_grades_sheet (integer, integer, integer, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar)
returns integer as '
declare
	p_item_id			alias for $1;
	p_revision_id		alias for $2;
	p_task_item_id			alias for $3;
	p_object_type		alias for $4;
	p_creation_date		alias for $5;
	p_creation_user 	alias for $6;
	p_creation_ip		alias for $7;
	p_title				alias for $8; -- default null
	p_publish_date		alias for $9;
	p_nls_language   	alias for $10; -- default null
	p_mime_type   		alias for $11; -- default null

	v_revision_id		integer;

begin

    v_revision_id := content_revision__new(
        p_title,               	-- title
		''grades sheet'',	 	-- description
		p_publish_date,			-- publish_date
		p_mime_type,			-- mime_type
		p_nls_language,			-- nls_language
		null,					-- data
		p_item_id,				-- item_id
		p_revision_id,			-- revision_id
		current_timestamp,		-- creation_date
		p_creation_user,		-- creation_user
		p_creation_ip,			-- creation_ip
	    null				    -- content length
    );

	insert into evaluation_grades_sheets
			(grades_sheet_id,
			grades_sheet_item_id,
	        task_item_id)
	values
			(v_revision_id, 
			p_item_id,
	   		p_task_item_id);

	return v_revision_id;
end;
' language 'plpgsql';

create function evaluation__delete_grades_sheet (integer)
returns integer as '
declare
	p_grades_sheet_id 	alias for $1;
begin
	
	delete from evaluation_grades_sheets where grades_sheet_id = p_grades_sheet_id;
	
	PERFORM  content_revision__delete(p_grades_sheet_id);

	return 0;

end;' language 'plpgsql';

---------------------------------------
-- STUDENT EVALUATIONS
---------------------------------------

create function evaluation__new_student_eval (integer, integer, integer, integer, numeric, char, text, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar)
returns integer as '
declare
	p_item_id			alias for $1;
	p_revision_id		alias for $2;
	p_task_item_id			alias for $3;
    p_party_id  	   	alias for $4;
	p_grade  		  	alias for $5;
  	p_show_student_p  	alias for $6;
 	p_description  	 	alias for $7;	
	p_object_type		alias for $8;
	p_creation_date		alias for $9;
	p_creation_user 	alias for $10;
	p_creation_ip		alias for $11;
	p_title				alias for $12; -- default null
	p_publish_date		alias for $13;
	p_nls_language   	alias for $14; -- default null
	p_mime_type   		alias for $15; -- default null

	v_revision_id		integer;

begin

    v_revision_id := content_revision__new(
        p_title,               	-- title
		p_description,	  	 	-- description
		p_publish_date,			-- publish_date
		p_mime_type,			-- mime_type
		p_nls_language,			-- nls_language
		null,					-- data
		p_item_id,				-- item_id
		p_revision_id,			-- revision_id
		current_timestamp,		-- creation_date
		p_creation_user,		-- creation_user
		p_creation_ip,			-- creation_ip
	    null				    -- content length
    );

	insert into evaluation_student_evals
			(evaluation_id,
			evaluation_item_id,
	        task_item_id,
	        party_id,
  			grade,
  			show_student_p)
	values
			(v_revision_id, 
			p_item_id,
	   		p_task_item_id,
    		p_party_id,
  			p_grade,
  		 	p_show_student_p);

	return v_revision_id;
end;' language 'plpgsql';

create function evaluation__delete_student_eval (integer)
returns integer as '
declare
	p_evaluation_id 	alias for $1;
begin
	
	delete from evaluation_student_evals where evaluation_id = p_evaluation_id;
	
	PERFORM  content_revision__delete(p_evaluation_id);

	return 0;

end;' language 'plpgsql';

---------------------------------------
-- EVALUATION TASK GROUPS
---------------------------------------

create function evaluation__new_evaluation_task_group(integer,varchar,varchar,timestamptz,integer,varchar,integer,integer)
returns integer as '
declare
        p_task_group_id                 alias for $1;
        p_task_group_name               alias for $2;
        p_join_policy                   alias for $3;
        p_creation_date                 alias for $4;
        p_creation_user                 alias for $5;
        p_creation_ip                   alias for $6;
        p_context_id                    alias for $7;
  	p_task_item_id     		alias for $8;

        v_group_id                      integer;

begin

        v_group_id := acs_group__new (
            p_task_group_id,
            ''evaluation_task_groups'',
            p_creation_date,
            p_creation_user,
            p_creation_ip,
            null,
            null,
            p_task_group_name,
            p_join_policy,
	    	p_context_id
        );

        insert into evaluation_task_groups
          	(group_id, 
	  		task_item_id)
        values
          	(v_group_id, 
		  	p_task_item_id);

        return v_group_id;        
end;
' language 'plpgsql';


create function evaluation__delete_evaluation_task_group(integer)
returns integer as '
declare
	  	p_task_group_id	  	alias for $1;
 		del_rec record;
begin

 	for del_rec in select evaluation_id from evaluation_student_evals where party_id = p_task_group_id
  	loop 
    	PERFORM content_revision__delete(del_rec.evaluation_id);
  	end loop;

 	for del_rec in select answer_id from evaluation_answers where party_id = p_task_group_id
  	loop 
    	PERFORM content_revision__delete(del_rec.answer_id);
  	end loop;

 	for del_rec in select rel_id from acs_rels where object_id_one = p_task_group_id
  	loop 
    	PERFORM acs_rel__delete(del_rec.rel_id);
  	end loop;

	delete from evaluation_task_groups
	where group_id = p_task_group_id;

	delete from groups where group_id = p_task_group_id;

	delete from parties where party_id = p_task_group_id;

	PERFORM acs_group__delete(p_task_group_id);

	return 0;
end;
' language 'plpgsql';

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
        null,
        'user',
        null,
        0,
        1
    );

---------------------------------------
-- GRADE FUNCTIONS
---------------------------------------

create function evaluation__task_grade (integer, integer)
returns numeric as '
declare

	p_user_id  	alias for $1;
	p_task_id 	alias for $2;

	v_grade	 	evaluation_student_evals.grade%TYPE;

begin

	select (ese.grade*et.weight*eg.weight)/10000 into v_grade
	from evaluation_student_evals ese, evaluation_tasks et, evaluation_grades eg
	where party_id = evaluation__party_id(p_user_id, et.task_id)
	  and et.task_id = p_task_id
	  and ese.task_item_id = et.task_item_id
	  and et.grade_item_id = eg.grade_item_id
	  and content_revision__is_live(eg.grade_id) = true
	  and content_revision__is_live(et.task_id) = true;

	if v_grade is null then
		return 0.00;
  	else
	  	return v_grade;
	end if;	
end;' language 'plpgsql';

create function evaluation__grade_total_grade (integer, integer)
returns numeric as '
declare

	p_user_id  	alias for $1;
	p_grade_id 	alias for $2;

	v_grade     evaluation_student_evals.grade%TYPE;
    v_grades_cursor RECORD;
        
begin

	v_grade := 0;
    FOR v_grades_cursor IN
        select (ese.grade*et.weight*eg.weight)/10000 as grade
        from   evaluation_grades eg, evaluation_tasks et, evaluation_student_evalsi ese
        where et.task_item_id = ese.task_item_id
		  and et.grade_item_id = eg.grade_item_id
          and eg.grade_id = p_grade_id
   		  and ese.party_id = evaluation__party_id(p_user_id,et.task_id)
		  and content_revision__is_live(ese.evaluation_id) = true	
		  and content_revision__is_live(et.task_id) = true	
    LOOP
		v_grade := v_grade + v_grades_cursor.grade;
    END LOOP;

	return v_grade;
end;' language 'plpgsql';

create function evaluation__class_total_grade (integer, integer)
returns numeric as '
declare

	p_user_id  	 	alias for $1;
 	p_package_id 	alias for $2;

	v_grade     evaluation_student_evals.grade%TYPE;
    v_grades_cursor RECORD;
        
begin

	v_grade := 0;
    FOR v_grades_cursor IN
        select (ese.grade*et.weight*eg.weight)/10000 as grade
        from evaluation_gradesx eg, evaluation_tasks et, evaluation_student_evalsi ese, acs_objects ao
        where et.task_item_id = ese.task_item_id
		  and et.grade_item_id = eg.grade_item_id
          and eg.item_id = ao.object_id
   		  and ao.context_id = p_package_id
   		  and ese.party_id = evaluation__party_id(p_user_id,et.task_id)
		  and content_revision__is_live(ese.evaluation_id) = true	
		  and content_revision__is_live(eg.grade_id) = true	
		  and content_revision__is_live(et.task_id) = true	
    LOOP
		v_grade := v_grade + v_grades_cursor.grade;
    END LOOP;

	return v_grade;
end;' language 'plpgsql';

---------------------------------------
-- OTHER FUNCTIONS
---------------------------------------

create function evaluation__party_name (integer,integer)
returns varchar as '
declare
	p_party_id 	alias for $1;
  	p_task_id  	alias for $2;

 	v_number_of_members evaluation_tasks.number_of_members%TYPE;
begin
	
	select number_of_members into v_number_of_members
	from evaluation_tasks
	where task_id = p_task_id;

	if v_number_of_members = 1 then
	  	return person__last_name(p_party_id)||'', ''||person__first_names(p_party_id);
	else
	  	return acs_group__name(p_party_id);
	end if;

end;' language 'plpgsql';

create function evaluation__party_id (integer,integer)
returns varchar as '
declare
	p_user_id 	alias for $1;
  	p_task_id  	alias for $2;

 	v_number_of_members evaluation_tasks.number_of_members%TYPE;
begin
	
	select number_of_members into v_number_of_members
	from evaluation_tasks
	where task_id = p_task_id;

	if v_number_of_members = 1 then
	  	return p_user_id;
	else
		return coalesce((select etg.group_id from evaluation_task_groups etg, 
						evaluation_tasks et,
						acs_rels map
						where map.object_id_one = etg.group_id
						  and map.object_id_two = p_user_id
 						  and etg.task_item_id = et.task_item_id
						  and et.task_id = p_task_id),0);
	end if;

end;' language 'plpgsql';

create function evaluation__new_folder (varchar,varchar,text,integer,varchar)
returns varchar as '
declare
	p_name  	 	alias for $1;
  	p_label   	 	alias for $2;
 	p_description  	alias for $3;
 	p_parent_id  	alias for $4;
  	p_content_type  alias for $5;

	v_folder_id 	cr_folders.folder_id%TYPE;

begin

    v_folder_id := content_folder__new(
        p_name, -- name
        p_label, -- label
        p_description, -- description
		p_parent_id      -- parent_id
    );
	-- associate content types witQh the folder
    PERFORM content_folder__register_content_type (
        v_folder_id,          -- folder_id
        p_content_type, -- content_type
        ''t''                 -- include_subtypes
    );
	
	return v_folder_id;
end;' language 'plpgsql';

create function evaluation__delete_all_folders_and_contents ()
returns integer as '
declare 
    v_folder_id   cr_folders.folder_id%TYPE; 
    v_item_id     cr_items.item_id%TYPE; 
    v_item_cursor RECORD; 

begin 
 
    select content_item__get_id(''evaluation_tasks_sols'', null, ''f'') into v_folder_id from dual; 
 
    -- delete all contents of the folder
    FOR v_item_cursor IN 
        select item_id 
        from   cr_items 
        where  parent_id = v_folder_id 
    LOOP 
    -- all attached types/item are deleted 
        PERFORM evaluation__delete_grade(v_item_cursor.item_id); 
    END LOOP; 
 
    -- unregister_content_types 
    PERFORM content_folder__unregister_content_type ( 
        v_folder_id,        -- folder_id 
        ''content_revision'', -- content_type 
        ''t''                 -- include_subtypes 
    ); 
    PERFORM content_folder__unregister_content_type ( 
        v_folder_id, -- folder_id 
        ''evaluation_tasks_sols'',      -- content_type 
        ''t''          -- include_subtypes 
    ); 
 
    -- this table must not hold reference to ''evaluation_tasks_sols'' type 
    delete from cr_folder_type_map where content_type = ''evaluation_tasks_sols''; 
 
    -- delete news folder 
    PERFORM content_folder__delete(v_folder_id); 
 
---------------- 
 
    select content_item__get_id(''evaluation_answers'', null, ''f'') into v_folder_id from dual; 
 
    -- delete all contents of the folder 
    FOR v_item_cursor IN 
        select item_id 
        from   cr_items 
        where  parent_id = v_folder_id 
    LOOP 
    -- all attached types/item are deleted 
        PERFORM evaluation__delete_grade(v_item_cursor.item_id); 
    END LOOP; 
 
    -- unregister_content_types 
    PERFORM content_folder__unregister_content_type ( 
        v_folder_id,        -- folder_id 
        ''content_revision'', -- content_type 
        ''t''                 -- include_subtypes 
    ); 
    PERFORM content_folder__unregister_content_type ( 
        v_folder_id, -- folder_id 
        ''evaluation_answers'',      -- content_type 
        ''t''          -- include_subtypes 
    ); 
 
    -- this table must not hold reference to ''evaluation_answers'' type 
    delete from cr_folder_type_map where content_type = ''evaluation_answers''; 
 
    -- delete news folder 
    PERFORM content_folder__delete(v_folder_id); 
  
---------------- 
 
    select content_item__get_id(''evaluation_student_evals'', null, ''f'') into v_folder_id from dual; 
 
    -- delete all contents of the folder 
    FOR v_item_cursor IN 
        select item_id 
        from   cr_items 
        where  parent_id = v_folder_id 
    LOOP 
    -- all attached types/item are deleted
        PERFORM evaluation__delete_grade(v_item_cursor.item_id); 
    END LOOP; 
 
    -- unregister_content_types 
    PERFORM content_folder__unregister_content_type ( 
        v_folder_id,        -- folder_id 
        ''content_revision'', -- content_type 
        ''t''                 -- include_subtypes 
    ); 
    PERFORM content_folder__unregister_content_type ( 
        v_folder_id, -- folder_id 
        ''evaluation_student_evals'',      -- content_type 
        ''t''          -- include_subtypes 
    ); 
 
    -- this table must not hold reference to ''evaluation_student_evals'' type 
    delete from cr_folder_type_map where content_type = ''evaluation_student_evals''; 
 
    -- delete news folder 
    PERFORM content_folder__delete(v_folder_id); 

---------------- 
 
    select content_item__get_id(''evaluation_grades_sheets'', null, ''f'') into v_folder_id from dual; 
 
    -- delete all contents of the folder 
    FOR v_item_cursor IN 
        select item_id 
        from   cr_items 
        where  parent_id = v_folder_id 
    LOOP 
    -- all attached types/item are deleted
        PERFORM evaluation__delete_grade(v_item_cursor.item_id); 
    END LOOP; 
 
    -- unregister_content_types 
    PERFORM content_folder__unregister_content_type ( 
        v_folder_id,        -- folder_id 
        ''content_revision'', -- content_type 
        ''t''                 -- include_subtypes 
    ); 
    PERFORM content_folder__unregister_content_type ( 
        v_folder_id, -- folder_id 
        ''evaluation_grades_sheets'',      -- content_type 
        ''t''          -- include_subtypes 
    ); 
 
    -- this table must not hold reference to ''evaluation_grades_sheets'' type 
    delete from cr_folder_type_map where content_type = ''evaluation_grades_sheets''; 
 
    -- delete news folder 
    PERFORM content_folder__delete(v_folder_id); 

----------------

    -- delete all contents
    FOR v_item_cursor IN
        select etg.group_id
        from   evaluation_tasks et, evaluation_task_groups etg
        where etg.task_item_id = et.task_item_id
    LOOP
       	PERFORM evaluation__delete_evaluation_task_group(v_item_cursor.group_id);
    END LOOP;

---------------- 
 
    select content_item__get_id(''evaluation_tasks'', null, ''f'') into v_folder_id from dual; 
 
    -- delete all contents of the folder 
    FOR v_item_cursor IN 
        select item_id 
        from   cr_items 
        where  parent_id = v_folder_id 
    LOOP 
    -- all attached types/item are deleted 
        PERFORM evaluation__delete_grade(v_item_cursor.item_id); 
    END LOOP; 
 
    -- unregister_content_types 
    PERFORM content_folder__unregister_content_type ( 
        v_folder_id,        -- folder_id 
        ''content_revision'', -- content_type 
        ''t''                 -- include_subtypes 
    ); 
    PERFORM content_folder__unregister_content_type ( 
        v_folder_id, -- folder_id 
        ''evaluation_tasks'',      -- content_type 
        ''t''          -- include_subtypes 
    ); 
 
    -- this table must not hold reference to ''evaluation_tasks'' type 
    delete from cr_folder_type_map where content_type = ''evaluation_tasks''; 
 
    -- delete news folder 
    PERFORM content_folder__delete(v_folder_id); 

---------------

    select content_item__get_id(''evaluation_grades'', null, ''f'') into v_folder_id from dual; 
 
    -- delete all contents of the folder 
    FOR v_item_cursor IN 
        select item_id 
        from   cr_items 
        where  parent_id = v_folder_id 
    LOOP 
    -- all attached types/item are deleted
        PERFORM evaluation__delete_grade(v_item_cursor.item_id); 
    END LOOP; 
 
    -- unregister_content_types 
    PERFORM content_folder__unregister_content_type ( 
        v_folder_id,        -- folder_id 
        ''content_revision'', -- content_type 
        ''t''                 -- include_subtypes 
    ); 
    PERFORM content_folder__unregister_content_type ( 
        v_folder_id, -- folder_id 
        ''evaluation_grades'',      -- content_type 
        ''t''          -- include_subtypes 
    ); 
 
    -- this table must not hold reference to ''evaluation_grades'' type 
    delete from cr_folder_type_map where content_type = ''evaluation_grades''; 
 
    -- delete news folder 
    PERFORM content_folder__delete(v_folder_id); 

 
    return 0; 
end;' language 'plpgsql';


create function evaluation__delete_contents (integer)
returns integer as '
declare

	p_package_id  	alias for $1;

	v_item_id     cr_items.item_id%TYPE;
    v_item_cursor RECORD;
        
begin

    -- delete all contents
    FOR v_item_cursor IN
        select ea.answer_id
        from   evaluation_answersi ea, acs_objects ao
        where ea.item_id = ao.object_id
   		  and ao.context_id = p_package_id
    LOOP
       	PERFORM evaluation__delete_answer(v_item_cursor.answer_id);
    END LOOP;

    -- delete all contents
    FOR v_item_cursor IN
        select ets.solution_id
        from   evaluation_tasks_solsi ets, acs_objects ao
        where ets.item_id = ao.object_id
   		  and ao.context_id = p_package_id
    LOOP
       	PERFORM evaluation__delete_task_sol(v_item_cursor.solution_id);
    END LOOP;

    -- delete all contents
    FOR v_item_cursor IN
        select egs.grades_sheet_id
        from   evaluation_grades_sheetsi egs, acs_objects ao
        where egs.item_id = ao.object_id
   		  and ao.context_id = p_package_id
    LOOP
       	PERFORM evaluation__delete_grades_sheet(v_item_cursor.grades_sheet_id);
    END LOOP;

    -- delete all contents
    FOR v_item_cursor IN
        select etg.group_id
        from   evaluation_tasksi et, acs_objects ao, evaluation_task_groups etg
        where et.item_id = ao.object_id
	   	  and etg.task_item_id = et.task_item_id
   		  and ao.context_id = p_package_id
    LOOP
       	PERFORM evaluation__delete_evaluation_task_group(v_item_cursor.group_id);
    END LOOP;

    -- delete all contents
    FOR v_item_cursor IN
        select ese.evaluation_id
        from   evaluation_student_evalsi ese, acs_objects ao
        where ese.item_id = ao.object_id
   		  and ao.context_id = p_package_id
    LOOP
       	PERFORM evaluation__delete_student_eval(v_item_cursor.evaluation_id);
    END LOOP;

    -- delete all contents
    FOR v_item_cursor IN
        select et.task_id
        from   evaluation_tasksi et, acs_objects ao
        where et.item_id = ao.object_id
   		  and ao.context_id = p_package_id
    LOOP
       	PERFORM evaluation__delete_task(v_item_cursor.task_id);
    END LOOP;

    -- delete all contents
    FOR v_item_cursor IN
        select eg.grade_id
        from   evaluation_gradesi eg, acs_objects ao
        where eg.item_id = ao.object_id
   		  and ao.context_id = p_package_id
    LOOP
       	PERFORM evaluation__delete_grade(v_item_cursor.grade_id);
    END LOOP;

	return 0;
end;' language 'plpgsql';

create function evaluation__delete_folder (integer,varchar)
returns integer as '
declare
  	p_folder_id		alias for $1;
 	p_content_type 	alias for $2;

    v_item_cursor RECORD;
begin

    FOR v_item_cursor IN
        select item_id
        from   cr_items
        where  parent_id = p_folder_id
    LOOP
       	PERFORM content_item__delete(v_item_cursor.item_id);
    END LOOP;

    -- unregister_content_types
    PERFORM content_folder__unregister_content_type (
        p_folder_id,        -- folder_id
        ''content_revision'', -- content_type
        ''t''                 -- include_subtypes
    );
    PERFORM content_folder__unregister_content_type (
        p_folder_id, -- folder_id
        p_content_type,      -- content_type
        ''t''          -- include_subtypes
    );

    delete from cr_folder_type_map where content_type = p_content_type;

    -- delete folder
    PERFORM content_folder__delete(p_folder_id);

	return 0;
end;' language 'plpgsql';

---------------------------------------
-- TEMPLATES
---------------------------------------

create or replace function inline_0 ()
returns integer as'
declare
    template_id integer;
begin

    -- Create the (default) content type template

    template_id := content_template__new( 
      ''evaluation-tasks-default'', -- name
      ''@text;noquote@'',               -- text
      true                      -- is_live
    );

    -- Register the template for the content type

    perform content_type__register_template(
      ''evaluation_tasks'', -- content_type
      template_id,             -- template_id
      ''public'',              -- use_context
      ''t''                    -- is_default
    );

    -- Create the (default) content type template

    template_id := content_template__new( 
      ''evaluation-tasks-sols-default'', -- name
      ''@text;noquote@'',               -- text
      true                      -- is_live
    );

    -- Register the template for the content type

    perform content_type__register_template(
      ''evaluation_tasks_sols'', -- content_type
      template_id,             -- template_id
      ''public'',              -- use_context
      ''t''                    -- is_default
    );

    -- Create the (default) content type template

    template_id := content_template__new( 
      ''evaluation-answers-default'', -- name
      ''@text;noquote@'',               -- text
      true                      -- is_live
    );

    -- Register the template for the content type

    perform content_type__register_template(
      ''evaluation_answers'', -- content_type
      template_id,             -- template_id
      ''public'',              -- use_context
      ''t''                    -- is_default
    );

    -- Create the (default) content type template

    template_id := content_template__new( 
      ''evaluation-grades-sheets-default'', -- name
      ''@text;noquote@'',               -- text
      true                      -- is_live
    );

    -- Register the template for the content type

    perform content_type__register_template(
      ''evaluation_grades_sheets'', -- content_type
      template_id,              	-- template_id
      ''public'',               	-- use_context
      ''t''                     	-- is_default
    );

    return null;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();

\i evaluation-calendar-create.sql
