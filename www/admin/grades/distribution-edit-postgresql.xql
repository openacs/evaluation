<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_grade_tasks">      
      <querytext>

		select task_name, 
		weight as task_weight,
		requires_grade_p,
		task_id
		from evaluation_tasksi
		where grade_id = :grade_id
		and content_revision__is_live(task_id) = true
   		order by task_name 
	
      </querytext>
</fullquery>

</queryset>
