<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_group_id">      
      <querytext>

	select coalesce((select etg2.group_id from evaluation_task_groups etg2, 
                                                      evaluation_tasks et2, 
                                                      acs_rels map 
                                                      where map.object_id_one = etg2.group_id 
                                                        and map.object_id_two = :student_id 
                                                        and etg2.task_item_id = et2.task_item_id 
                                                        and et2.task_id = :task_id),0)
               from evaluation_tasks et3 
              where et3.task_id = :task_id 

--	select evaluation__party_id(:student_id,:task_id)
	
      </querytext>
</fullquery>

<fullquery name="group_name">      
      <querytext>

	select acs_group__name(:group_id)

      </querytext>
</fullquery>

<fullquery name="get_answer_data">      
      <querytext>
	
    select ea.answer_id 
    from evaluation_answers ea,
	 cr_items cri
    where cri.live_revision = ea.answer_id
      and ea.party_id = 
	( select
	CASE 
	  WHEN et3.number_of_members = 1 THEN :student_id
	  ELSE 
	(select etg2.group_id from evaluation_task_groups etg2,
                                                      evaluation_tasks et2,
                                                      acs_rels map
                                                      where map.object_id_one = etg2.group_id
                                                        and map.object_id_two = :student_id
                                                        and etg2.task_item_id = et2.task_item_id
                                                        and et2.task_id = :task_id)
	END as nom
               from evaluation_tasks et3
              where et3.task_id = :task_id
	)
--evaluation__party_id(:student_id,:task_id)
      and ea.task_item_id = :task_item_id

      </querytext>
</fullquery>

<fullquery name="get_grade_info">      
      <querytext>

	select round(ese.grade,2) as grade,
	ese.description as comments,
	round((ese.grade*:t_weight*:g_weight)/10000,2) as net_grade,
	person__name(ese.creation_user) as grader_name
	from evaluation_student_evalsi ese,
	cr_items cri, 
	evaluation_tasks et
	where ese.task_item_id = et.task_item_id
	and et.task_id = :task_id
	and cri.live_revision = ese.evaluation_id
	and ese.party_id = 
	( select
	CASE 
	  WHEN et3.number_of_members = 1 THEN :student_id
	  ELSE 
	(select etg2.group_id from evaluation_task_groups etg2,
                                                      evaluation_tasks et2,
                                                      acs_rels map
                                                      where map.object_id_one = etg2.group_id
                                                        and map.object_id_two = :student_id
                                                        and etg2.task_item_id = et2.task_item_id
                                                        and et2.task_id = :task_id)
	END as nom
               from evaluation_tasks et3
              where et3.task_id = :task_id
	)

-- evaluation__party_id(:student_id,:task_id)

      </querytext>
</fullquery>
    
</queryset>
