-- jopez@inv.it.uc3m.es

---------------------------------------
-- GRADES
---------------------------------------
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
	p_estimated_time		alias for $12;
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

create function evaluation__delete_contents (integer)
returns integer as '
declare

	p_package_id  	alias for $1;

	v_item_id     cr_items.item_id%TYPE;
    v_item_cursor RECORD;
        
begin
    FOR v_item_cursor IN
        select etg.group_id
        from   evaluation_tasksi et, acs_objects ao, evaluation_task_groups etg
        where et.item_id = ao.object_id
	   	  and etg.task_item_id = et.task_item_id
   		  and ao.context_id = p_package_id
    LOOP
       	PERFORM evaluation__delete_evaluation_task_group(v_item_cursor.group_id);
    END LOOP;
return 0;
end;' language 'plpgsql';
