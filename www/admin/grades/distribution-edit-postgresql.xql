<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_grade_tasks">      
      <querytext>

		select et.task_name, 
		et.weight as task_weight,
		et.requires_grade_p,
		et.task_id,
		(select points from evaluation_tasks where task_id=et.task_id) as points,
		(select relative_weight from evaluation_tasks where task_id=et.task_id) as relative_weight
		from evaluation_tasksi et
		where et.grade_item_id = :grade_item_id
		and content_revision__is_live(et.task_id) = true
   		order by task_name 
	
      </querytext>
</fullquery>

</queryset>
