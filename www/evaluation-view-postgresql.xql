<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_evaluation_info">      
      <querytext>

    select ese.grade,
    ese.party_id,
    et.weight as task_weight,
    et.task_id,
    et.task_item_id,
    to_char(et.due_date, 'YYYY-MM-DD HH24:MI:SS') as due_date_ansi,
    et.due_date,
    et.task_name,
    eg.grade_name,
    eg.grade_plural_name,
    eg.weight as grade_weight,
    (et.weight*eg.weight*ese.grade/10000) as net_grade,
    et.number_of_members,
    coalesce(person__name(ese.modifying_user),person__name(creation_user)) as grader,
    to_char(ese.last_modified, 'YYYY-MM-DD HH24:MI:SS') as evaluation_date_ansi,
    ese.description as comments
    from evaluation_student_evalsi ese,
    evaluation_tasks et,
    evaluation_grades eg,
    cr_items cri1, cr_items cri2
    where ese.evaluation_id = :evaluation_id
	and ese.show_student_p = 't'
    and ese.task_item_id = et.task_item_id
    and et.grade_item_id = eg.grade_item_id
    and cri1.live_revision = et.task_id
    and cri2.live_revision = eg.grade_id

      </querytext>
</fullquery>

<fullquery name="get_answer_info">      
      <querytext>

    select ea.data as answer_data,
    ea.title as answer_title,
    ea.revision_id as answer_revision_id,
    to_char(ea.creation_date, 'YYYY-MM-DD HH24:MI:SS') as submission_date_ansi,
    ea.last_modified as submission_date,
    coalesce(person__name(modifying_user),person__name(creation_user)) as answer_owner
    from evaluation_answersi ea, cr_items cri
    where ea.party_id = 
	( select 
	CASE  
	  WHEN et3.number_of_members = 1 THEN :user_id 
	  ELSE  
	(select etg2.group_id from evaluation_task_groups etg2, 
                                                      evaluation_tasks et2, 
                                                      acs_rels map 
                                                      where map.object_id_one = etg2.group_id 
                                                        and map.object_id_two = :user_id 
                                                        and etg2.task_item_id = et2.task_item_id 
                                                        and et2.task_id = :task_id) 
	END as nom 
               from evaluation_tasks et3 
              where et3.task_id = :task_id 
	) 
    and ea.task_item_id = :task_item_id
    and cri.live_revision = ea.answer_id

      </querytext>
</fullquery>

<fullquery name="get_group_info">      
      <querytext>

	select acs_group__name(:party_id) as group_name

      </querytext>
</fullquery>

<fullquery name="group_members">      
      <querytext>

	select person__name(map.object_id_two) as member_name
	from acs_rels map 
	where map.object_id_one = :party_id
    
      </querytext>
</fullquery>

</queryset>
