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
	select grade_name into v_grade_name
		from evaluation_grades
		where grade_id = p_grade_id;

    return v_grade_name;
end;
' language 'plpgsql';

---------------------------------------
-- TASKS
---------------------------------------

create function task__name(integer)
returns varchar as '
declare 
    p_task_id      alias for $1;
    v_task_name    evaluation_tasks.task_name%TYPE;
begin
	select task_name into v_task_name
		from evaluation_tasks
		where task_id = p_task_id;

    return v_task_name;
end;
' language 'plpgsql';

create function evaluation__clone_task(integer,integer)
returns integer as '
declare 
    p_from_revision_id      alias for $1;
    p_to_revision_id 	    alias for $2;
    v_content_length	    cr_revisions.content_length%TYPE;
    v_lob 	            cr_revisions.lob%TYPE;
    v_content 		    cr_revisions.content%TYPE;
begin
    select content, 
	content_length,
	lob
    into
	v_content,
	v_content_length,
	v_lob
    from cr_revisions
    where revision_id = p_from_revision_id;

    update cr_revisions	
    set content = v_content,
    content_length = v_content_length,
    lob = v_lob
    where revision_id = p_to_revision_id;

    return p_to_revision_id;
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

create function evaluation__clone (integer,integer)
returns integer as '
declare
 p_new_package_id  	alias for $1;   --default null,
 p_old_package_id 	alias for $2;   --default null
 v_grade_id 	        evaluation_grades.grade_id%TYPE;
 v_item_id		acs_objects.object_id%TYPE;	
 v_revision_id		acs_objects.object_id%TYPE;	
 v_task_item_id		acs_objects.object_id%TYPE;	
 v_task_revision_id	acs_objects.object_id%TYPE;	
 one_grade		record;
 entry			record;

begin
            -- get all the grades belonging to the old package,
            -- and create new grades for the new package
	    delete from evaluation_grades where grade_id in (select eg.grade_id from acs_objects o, evaluation_grades eg,cr_items ci,cr_revisions cr  where o.object_id = ci.item_id and cr.revision_id=eg.grade_id  and ci.item_id=cr.item_id  and cr.revision_id=ci.live_revision and o.context_id = p_new_package_id);

            for one_grade in select *
                            from acs_objects o, evaluation_grades eg,cr_items ci,cr_revisions cr
                            where o.object_id = ci.item_id
			    and cr.revision_id=eg.grade_id 
			    and ci.item_id=cr.item_id
			    and cr.revision_id=ci.live_revision
                            and o.context_id = p_old_package_id
			    
            loop
	       
	       v_item_id :=  evaluation__new_item (null,
						   one_grade.name,
						   null,
						   one_grade.creation_user,
						   p_new_package_id,
						   one_grade.creation_date,
						   one_grade.creation_ip,
						   one_grade.title,
						   one_grade.description,
						   one_grade.mime_type,
						   null,
						   null,
						   ''text'',
						   ''content_item'',
						   ''evaluation_grades''
						);
	       
       	       v_revision_id := nextval(''t_acs_object_id_seq'');
               v_grade_id := evaluation__new_grade (	v_item_id,
							v_revision_id,
							one_grade.grade_name,
							one_grade.grade_plural_name,
							one_grade.weight,
							''evaluation_grades'',
							one_grade.creation_date,
							one_grade.creation_user,
							one_grade.creation_ip,
							one_grade.title,
							one_grade.description,
							one_grade.publish_date,
							null,
							''text/plain''
							);

           	for entry in select *, (ci.live_revision = cr.revision_id) as live_p from evaluation_tasks et,cr_revisions cr,cr_items ci, acs_objects o where grade_item_id = one_grade.grade_item_id and cr.revision_id=task_id and cr.item_id=ci.item_id and object_id=ci.item_id order by task_item_id

           	loop

				v_task_item_id := evaluation__new_item (
					     null, 
					     entry.name,
					     null, 
					     entry.creation_user,
					     p_new_package_id,
					     now(),
					     entry.creation_ip,
					     entry.task_name,
					     entry.description,
					     entry.mime_type, 
					     null, 
					     null, 
					     entry.storage_type, --storage_type
					     ''content_item'', -- item_subtype
					     ''evaluation_tasks'' -- content_type
					     );
				

      	                v_task_revision_id := nextval(''t_acs_object_id_seq'');
         		perform  evaluation__new_task (		v_task_item_id,
						    	  	v_task_revision_id,
								entry.task_name,
								entry.number_of_members,
								v_item_id,
								entry.description,
								entry.weight,
								entry.due_date,
							 	entry.late_submit_p,
								entry.online_p,
								entry.requires_grade_p,
								entry.estimated_time,
								entry.object_type,
								entry.creation_date,
								entry.creation_user,
								entry.creation_ip,
								entry.title,
								entry.publish_date,
								entry.nls_language,
								entry.mime_type
							);

		update evaluation_tasks set points=entry.points, relative_weight=entry.relative_weight, perfect_score= entry.perfect_score,forums_related_p=entry.forums_related_p  where task_id=v_task_revision_id;

        	   perform  content_item__set_live_revision (
					    v_task_revision_id			
						   );


               end loop;
	   perform  content_item__set_live_revision (
					    v_revision_id			
						   );

           end loop;
 return 0;
 end;
' language 'plpgsql';
