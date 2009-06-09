<?xml version="1.0"?>

<queryset>

<fullquery name="get_grade_info">      
      <querytext>

		select grade_plural_name,grade_name,weight as grade_weight,weight as category_weight from evaluation_grades where grade_id = :grade_id
	
      </querytext>
</fullquery>

<fullquery name="solution_info">      
      <querytext>

	    select ets.solution_id
	    from evaluation_tasks_sols ets, cr_items cri
	    where ets.task_item_id = (select task_item_id from evaluation_tasks where task_id=:task_id)
	    and cri.live_revision = ets.solution_id
	
      </querytext>
</fullquery>

<fullquery name="answer_info">      
      <querytext>

      select ea.answer_id
      from evaluation_answers ea, cr_items cri
      where ea.task_item_id = :task_item_id 
      and cri.live_revision = ea.answer_id
      and ea.party_id = 
	( select 
	CASE  
	  WHEN et3.number_of_members = 1 THEN 
	  (select user_id from users where user_id = :user_id)
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

 --evaluation__party_id(:user_id,:task_id)
      
      </querytext>
</fullquery>

</queryset>
