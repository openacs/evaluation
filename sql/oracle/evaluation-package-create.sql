--jopez@galileo.edu
--cesarhj@galileo.edu

----------------------
-- Package definition
----------------------

create package evaluation
as	
 function grade_name (
       grade_id  in evaluation_grades.grade_id%TYPE  
 ) return varchar;

 function task_name (
       task_id  in evaluation_tasks.task_id%TYPE
 ) return varchar;

 function party_name (
       p_party_id in parties.party_id%TYPE,    
       p_task_id  in evaluation_tasks.task_id%TYPE
 ) return varchar;

 function party_id (
       p_user_id in users.user_id%TYPE,
       p_task_id in evaluation_tasks.task_id%TYPE
 ) return integer;

 function answer_info (
       p_user_id in users.user_id%TYPE,
       p_task_id in evaluation_tasks.task_id%TYPE,
       p_task_item_id in evaluation_tasks.task_item_id%TYPE
 ) return integer;

 function class_total_grade (                                                                                                            
       p_user_id in users.user_id%TYPE,
       p_package_id in acs_objects.context_id%TYPE
 ) return number;

 function grade_total_grade (                                                                                                            
       p_user_id in users.user_id%TYPE,
       p_grade_id in evaluation_grades.grade_id%TYPE
 ) return number;

 function task_grade (                                                                                                            
       p_user_id in users.user_id%TYPE,
       p_task_id in evaluation_tasks.task_id%TYPE
 ) return number;

 function new_evaluation_task_group (
       p_task_group_id integer,  
       p_task_group_name varchar,
       p_join_policy varchar,    
       p_creation_date date,  
       p_creation_user integer,   
       p_creation_ip varchar,    
       p_context_id integer,     
       p_task_item_id integer       
 ) return integer;

 function evaluation_group_member_add (
       p_evaluation_group_id in evaluation_task_groups.group_id%TYPE,
       p_user_id in users.user_id%TYPE,
       p_package_id in acs_objects.object_id%TYPE,
       p_creation_user_id in users.user_id%TYPE,
       p_creation_ip in acs_objects.creation_ip%TYPE
 ) return integer;

 function delete_evaluation_task_group (
       p_task_group_id in groups.group_id%TYPE
 ) return integer;

 procedure clone_task (
	p_from_revision_id in cr_revisions.revision_id%TYPE,
	p_to_revision_id in cr_revisions.revision_id%TYPE
 );
end evaluation;
/
show errors;

------------------
-- Package Body
------------------

create package body evaluation 
as 
 
 function grade_name ( 
       grade_id in evaluation_grades.grade_id%TYPE
 ) return varchar 
 is 
       v_grade_name evaluation_grades.grade_name%TYPE;
 begin 
 	select grade_name into v_grade_name 
 	from evaluation_grades where grade_id = grade_name.grade_id; 
 	return v_grade_name; 
 end grade_name; 

 function task_name
 (
       task_id in evaluation_tasks.task_id%TYPE
 ) return varchar
 is
       v_task_name evaluation_tasks.task_name%TYPE;
 begin
 	select task_name into  v_task_name 
 	from evaluation_tasks where task_id = task_name.task_id;
 	return v_task_name;
 end task_name;

 function party_name (
       p_party_id in parties.party_id%TYPE,
       p_task_id  in evaluation_tasks.task_id%TYPE
 ) return varchar
 is
       v_number_of_members evaluation_tasks.number_of_members%TYPE;    
 begin
        select number_of_members into v_number_of_members
        from evaluation_tasks
        where task_id = party_name.p_task_id;
		if v_number_of_members = 1 then
                return person.last_name(p_party_id)||', '||person.first_names(p_party_id);
        else
                return acs_group.name(p_party_id);
        end if;
 end party_name;

 function party_id (
       p_user_id in users.user_id%TYPE,
       p_task_id in evaluation_tasks.task_id%TYPE
 ) return integer
 is 
       v_number_of_members evaluation_tasks.number_of_members%TYPE;
       v_temp parties.party_id%TYPE;
 begin
       select number_of_members into v_number_of_members
       from evaluation_tasks
       where task_id = party_id.p_task_id;
       if v_number_of_members = 1 then
                return party_id.p_user_id;
       else
      	 	select nvl(etg.group_id,0) into v_temp from evaluation_task_groups etg,
                                                evaluation_tasks et,
                                                acs_rels map
                                                where map.object_id_one = etg.group_id
                                                  and map.object_id_two = party_id.p_user_id
                                                  and etg.task_item_id = et.task_item_id
                                                  and et.task_id = party_id.p_task_id;
          return v_temp;
       end if;
 end party_id;

 function answer_info (
       p_user_id in users.user_id%TYPE,
       p_task_id in evaluation_tasks.task_id%TYPE,
       p_task_item_id in evaluation_tasks.task_item_id%TYPE
 ) return integer
 is
       v_answer_id evaluation_student_evals.grade%TYPE;
 begin
       select ea.answer_id into v_answer_id
       from evaluation_answers ea, cr_items cri
       where ea.task_item_id = p_task_item_id
       and cri.live_revision = ea.answer_id
       and ea.party_id = evaluation.party_id(p_user_id,p_task_id);

       return v_answer_id;
 end answer_info;

 function class_total_grade (
       p_user_id in users.user_id%TYPE,
       p_package_id in acs_objects.context_id%TYPE
 ) return number
 is
       v_grade evaluation_student_evals.grade%TYPE;
 begin
       select nvl(sum(ese.grade*et.weight*eg.weight/10000),0) into v_grade
        from evaluation_grades eg, 
        evaluation_tasks et, 
        evaluation_student_evals ese, 
        acs_objects ao,
	    cr_items cri1, cr_items cri2, cr_items cri3 
        where et.task_item_id = ese.task_item_id 
		  and et.grade_item_id = eg.grade_item_id 
          and eg.grade_item_id = ao.object_id 
   		  and ao.context_id = p_package_id 
   		  and ese.party_id = evaluation.party_id(p_user_id,et.task_id) 
	      and cri1.live_revision = eg.grade_id
	      and cri2.live_revision = et.task_id
	      and cri3.live_revision = ese.evaluation_id;

       return v_grade;
 end class_total_grade;

 function grade_total_grade (                                                                                                            
       p_user_id in users.user_id%TYPE,
       p_grade_id in evaluation_grades.grade_id%TYPE
 ) return number
 is
       v_grade evaluation_student_evals.grade%TYPE;
 begin

	select nvl(sum((ese.grade*et.weight*eg.weight)/10000),0) into v_grade
        from   evaluation_grades eg, evaluation_tasks et, evaluation_student_evals ese
        where et.task_item_id = ese.task_item_id 
		  and et.grade_item_id = eg.grade_item_id 
          and eg.grade_id = p_grade_id 
   		  and ese.party_id = evaluation.party_id(p_user_id,et.task_id)
		  and et.requires_grade_p = 't'
		  and exists (select 1 from cr_items where live_revision = et.task_id) 
	      and exists (select 1 from cr_items where live_revision = ese.evaluation_id);

    return v_grade; 
 end grade_total_grade;

 function task_grade (                                                                                                            
       p_user_id in users.user_id%TYPE,
       p_task_id in evaluation_tasks.task_id%TYPE
 ) return number
 is
       v_grade evaluation_student_evals.grade%TYPE;
 begin

	select nvl(sum(ese.grade*et.weight*eg.weight/10000),0) into v_grade
	from evaluation_student_evals ese, evaluation_tasks et, evaluation_grades eg,
	cr_items cri1, cr_items cri2
	where party_id = evaluation.party_id(p_user_id,p_task_id)
	  and et.task_id = p_task_id
	  and ese.task_item_id = et.task_item_id
	  and et.grade_item_id = eg.grade_item_id
	  and cri1.live_revision = ese.evaluation_id
	  and cri2.live_revision = eg.grade_id;
	
	return v_grade;
 end task_grade;

 function new_evaluation_task_group (
       p_task_group_id integer,
       p_task_group_name varchar,
       p_join_policy varchar,
       p_creation_date date,
       p_creation_user integer,
       p_creation_ip varchar,
       p_context_id integer,
       p_task_item_id integer
 ) return integer
 is
       v_group_id integer;
 begin
       v_group_id := acs_group.new (
            p_task_group_id,
            'evaluation_task_groups',
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
 end new_evaluation_task_group;

 function evaluation_group_member_add (
       p_evaluation_group_id evaluation_task_groups.group_id%TYPE,
       p_user_id users.user_id%TYPE,
       p_package_id acs_objects.object_id%TYPE,
       p_creation_user_id users.user_id%TYPE,
       p_creation_ip acs_objects.creation_ip%TYPE
 ) return integer
 is
       v_rel_id acs_rels.rel_id%TYPE;
       v_count integer;
 begin
	v_rel_id := 0;
	select count(*) into v_count from acs_rels 
	                where object_id_one = p_evaluation_group_id 
	                and object_id_two = p_user_id
	                and rel_type = 'evaluation_task_group_rel';

	if v_count = 0 then
	v_rel_id := acs_rel.new (
						 null,
						 'evaluation_task_group_rel',
						 p_evaluation_group_id,
						 p_user_id,
						 p_package_id,
						 p_creation_user_id,
						 p_creation_ip
						 );
	end if;

  return v_rel_id;
 end evaluation_group_member_add;

 function delete_evaluation_task_group (
       p_task_group_id groups.group_id%TYPE
 ) return integer
 is
       total integer;
 begin
        total := 0;
        FOR row in (select evaluation_id from evaluation_student_evals where party_id = p_task_group_id)
        LOOP
        content_revision.del(revision_id => row.evaluation_id);
        END LOOP;
        
        FOR row in (select answer_id from evaluation_answers where party_id = p_task_group_id)
        LOOP
        content_revision.del(revision_id => row.answer_id);
        END LOOP;

        FOR row in (select rel_id from acs_rels where object_id_one = p_task_group_id)
        LOOP
        acs_rel.del(rel_id => row.rel_id);
        END LOOP;

        delete from evaluation_task_groups
        where group_id = p_task_group_id;

        delete from groups where group_id = p_task_group_id;
        delete from parties where party_id = p_task_group_id;

        acs_group.del(p_task_group_id);
    return total;
 end delete_evaluation_task_group;

 procedure clone_task (
	p_from_revision_id in cr_revisions.revision_id%TYPE,
	p_to_revision_id in cr_revisions.revision_id%TYPE
 )
 is
 	v_bdata		        BLOB;
 	v_ddata             	BLOB;
 	v_content_length    	cr_revisions.content_length%TYPE;	
	v_filename 	        cr_revisions.filename%TYPE;
 begin
	select	content,
	dbms_lob.getlength(content),
	filename
	into v_bdata,
	v_content_length,
	v_filename
	from cr_revisions
	where revision_id = p_from_revision_id;

	select content into v_ddata
	from cr_revisions 
	where revision_id = p_to_revision_id
	for update;
	
	if v_content_length > 0 then
	dbms_lob.copy  (
			dest_lob    => v_ddata,
			src_lob	    => v_bdata,
			amount	    => v_content_length
			);
	end if;
	
	update cr_revisions	
 	set content_length = v_content_length,
	filename = v_filename
	where revision_id = p_to_revision_id;

 end clone_task;

end evaluation;
/
show errors;

