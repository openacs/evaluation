<?xml version="1.0"?>

<queryset>

<fullquery name="grade_names">      
      <querytext>
		select eg.grade_name, eg.grade_plural_name 
		from evaluation_grades eg, cr_items cri
		where eg.grade_item_id = :grade_item_id 
		and cri.live_revision = eg.grade_id
      </querytext>
</fullquery>

<fullquery name="solution_info">      
      <querytext>
	    select ets.solution_id
	    from evaluation_tasks_sols ets, cr_items cri
	    where ets.task_item_id = :task_item_id
	    and cri.live_revision = ets.solution_id
      </querytext>
</fullquery>


</queryset>
