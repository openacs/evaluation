<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_grade_tasks">      
      <querytext>

		select task_name, 
		weight as task_weight,
		requires_grade_p,
		task_id
		from evaluation_tasksi
		where grade_item_id = :grade_item_id
		and content_revision__is_live(task_id) = true
   		order by task_name 
	
      </querytext>
</fullquery>
</queryset>