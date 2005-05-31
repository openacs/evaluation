<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_grade_info">      
      <querytext>

		select upper(grade_plural_name) as grade_plural_name, grade_plural_name as low_name,grade_name,weight as grade_weight,weight as category_weight from evaluation_grades where grade_id = :grade_id
	
      </querytext>
</fullquery>

<fullquery name="get_tasks_admin">      
      <querytext>

	select et.task_name, 
	round(et.weight,2) as task_weight,
        et.task_id, (select perfect_score from evaluation_tasks where task_id=et.task_id) as perfect_score, online_p
	from evaluation_tasksi et, cr_items cri
	where grade_item_id = :grade_item_id
	  and cri.live_revision = et.task_id
      $evaluations_orderby
	
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


<fullquery name="get_grade_tasks">      
      <querytext>

	select et.task_name, 
	et.task_item_id,
	et.weight as t_weight,
	eg.weight as g_weight,
	round((et.weight*eg.weight)/100,2) as task_weight,
	et.number_of_members, 
	et.online_p,
	et.due_date,
	et.late_submit_p,
        et.task_id, (select perfect_score from evaluation_tasks where task_id=et.task_id) as perfect_score
	from evaluation_grades eg,
	evaluation_tasksi et,
	cr_items cri
	where eg.grade_id = :grade_id
	and eg.grade_item_id = et.grade_item_id
	and cri.live_revision = et.task_id
	$evaluations_orderby
	
      </querytext>
</fullquery>

</queryset>
