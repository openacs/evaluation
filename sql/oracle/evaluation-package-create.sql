--jopez@galileo.edu
--cesarhj@galileo.edu

----------------------
-- Package definition
----------------------

create or replace package evaluation
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
       p_package_id acs_objects.context_id%TYPE
 ) return integer;
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
 function delete_evaluation_task_group (
       p_task_group_id groups.group_id%TYPE
 ) return integer;
end evaluation;
/
show errors;

------------------
-- Package Body
------------------

create or replace package body evaluation 
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
        where task_id = party_name.p_task_id;                                                                                                                                  if v_number_of_members = 1 then
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
       where ea.task_item_id = answer_info.p_task_item_id
       and cri.live_revision = ea.answer_id
       and ea.party_id =
        ( select
       CASE
          WHEN et3.number_of_members = 1 THEN answer_info.p_user_id
          ELSE
        (select etg2.group_id from evaluation_task_groups etg2,
                                                      evaluation_tasks et2,
                                                      acs_rels map
                                                      where map.object_id_one = etg2.group_id
                                                        and map.object_id_two = answer_info.p_user_id
                                                        and etg2.task_item_id = et2.task_item_id
                                                        and et2.task_id = answer_info.p_task_id)
        END as nom
               from evaluation_tasks et3
              where et3.task_id = answer_info.p_task_id
        );
        return v_answer_id;
 end answer_info;

function class_total_grade (
       p_user_id in users.user_id%TYPE,
       p_package_id in acs_objects.context_id%TYPE
 ) return integer
 is
       v_grade evaluation_student_evals.grade%TYPE;
 begin
       v_grade := 0;
       FOR row in (select nvl(sum(round((ese.grade*et.weight*eg.weight)/10000,2)),0) as grade
        from evaluation_grades eg, evaluation_tasks et, evaluation_student_evals ese, acs_objects ao, cr_items cri1, cr_items cri2, cr_items cri3
        where et.task_item_id = ese.task_item_id and et.grade_item_id = eg.grade_item_id and eg.grade_item_id = ao.object_id  and ao.context_id = class_total_grade.p_package_id and ese.party_id =
        ( select
        CASE
          WHEN et3.number_of_members = 1 THEN class_total_grade.p_user_id
          ELSE
        (select etg2.group_id from evaluation_task_groups etg2,
                                                      evaluation_tasks et2,
                                                      acs_rels map
                                                      where map.object_id_one = etg2.group_id
                                                        and map.object_id_two = class_total_grade.p_user_id
                                                        and etg2.task_item_id = et2.task_item_id
                                                        and et2.task_id = et.task_id)
        END as nom
               from evaluation_tasks et3
              where et3.task_id = et.task_id
        )
        and cri1.live_revision = eg.grade_id
        and cri2.live_revision = et.task_id
        and cri3.live_revision = ese.evaluation_id)      
       LOOP
            v_grade := v_grade + row.grade;
       END LOOP;
       return v_grade;
end class_total_grade;

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

end evaluation;
/
show errors;

