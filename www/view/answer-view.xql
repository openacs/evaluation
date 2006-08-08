<?xml version="1.0"?>

<queryset>
<fullquery name="get_answer_info">      
      <querytext>
	    select ea.data as answer_data, 
	    ea.title as answer_title, 
	    to_char(ea.creation_date,'MM/DD/YYYY HH24:MI') as creation_date
	    from evaluation_answersi ea, cr_items cri
	    where ea.task_item_id = :task_item_id 
	    and answer_item_id=:answer_item_id
	    and cri.item_id=:answer_item_id
	    and answer_id=:answer_id
	    and ea.party_id = 
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

-- evaluation__party_id(:user_id,:task_id)

      </querytext>
</fullquery>
<fullquery name="get_group_id">      
      <querytext>

	select coalesce((select etg2.group_id from evaluation_task_groups etg2, 
                                                      evaluation_tasks et2, 
                                                      acs_rels map 
                                                      where map.object_id_one = etg2.group_id 
                                                        and map.object_id_two = :user_id 
                                                        and etg2.task_item_id = et2.task_item_id 
                                                        and et2.task_id = :task_id),0)
               from evaluation_tasks et3 
              where et3.task_id = :task_id 

--		select evaluation__party_id(:user_id,:task_id)
	
      </querytext>
</fullquery>

<fullquery name="get_task_info">      
      <querytext>
       select task_id, task_item_id, task_name,upper(task_name) as name,number_of_members, due_date, grade_item_id, weight,online_p, late_submit_p, requires_grade_p, estimated_time, points, perfect_score ,relative_weight,forums_related_p from evaluation_tasks where task_id=:task_id
      </querytext>
</fullquery>
<fullquery name="answers">      
      <querytext>
	select * from evaluation_answers where answer_item_id=(select answer_item_id from evaluation_answers where answer_id=:answer_id)
      </querytext>
</fullquery>
<fullquery name="compare_due_date">      
      <querytext>

	select 1 from dual where :due_date > now()
	
      </querytext>
</fullquery>


</queryset>