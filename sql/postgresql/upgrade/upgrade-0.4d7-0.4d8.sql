alter table evaluation_tasks add column forums_related_p char(1) constraint evaluation_tasks_frp_ck check(forums_related_p in ('t','f'));



-- added
select define_function_args('evaluation__clone','new_package_id,old_package_id');

--
-- procedure evaluation__clone/2
--
CREATE OR REPLACE FUNCTION evaluation__clone(
   p_new_package_id integer, --default null,
   p_old_package_id integer  --default null

) RETURNS integer AS $$
DECLARE
 v_grade_id 	        evaluation_grades.grade_id%TYPE;
 v_item_id		acs_objects.object_id%TYPE;	
 v_revision_id		acs_objects.object_id%TYPE;	
 v_task_item_id		acs_objects.object_id%TYPE;	
 v_task_revision_id	acs_objects.object_id%TYPE;	
 previous		integer default 0;
 one_grade		record;
 entry			record;

BEGIN
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
						   'text',
						   'content_item',
						   'evaluation_grades'
						);
	       
       	       v_revision_id := nextval('t_acs_object_id_seq');
               v_grade_id := evaluation__new_grade (	v_item_id,
							v_revision_id,
							one_grade.grade_name,
							one_grade.grade_plural_name,
							one_grade.weight,
							'evaluation_grades',
							one_grade.creation_date,
							one_grade.creation_user,
							one_grade.creation_ip,
							one_grade.title,
							one_grade.description,
							one_grade.publish_date,
							null,
							'text/plain'
							);

           	for entry in select *, (ci.live_revision = cr.revision_id) as live_p from evaluation_tasks et,cr_revisions cr,cr_items ci, acs_objects o where grade_item_id = one_grade.grade_item_id and cr.revision_id=task_id and cr.item_id=ci.item_id and object_id=ci.item_id order by task_item_id

           	loop
			if previous != entry.task_item_id then

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
					     'content_item', -- item_subtype
					     'evaluation_tasks' -- content_type
					     );
				
			end if;

      	                v_task_revision_id := nextval('t_acs_object_id_seq');
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

		if entry.live_p then
        	   perform  content_item__set_live_revision (
					    v_task_revision_id			
						   );
		end if;

		previous := entry.task_item_id;

               end loop;
	   perform  content_item__set_live_revision (
					    v_revision_id			
						   );

           end loop;
 return 0;
 END;

$$ LANGUAGE plpgsql;
