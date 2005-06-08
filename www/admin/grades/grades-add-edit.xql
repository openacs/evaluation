<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_grade_info">      
      <querytext>

		select grade_name, grade_plural_name, comments, weight
		from evaluation_grades
		where grade_id = :grade_id

	
      </querytext>
</fullquery>

<fullquery name="get_grade_tasks">      
      <querytext>

		select 	et.task_id,
		(select points from evaluation_tasks where task_id=et.task_id) as points
		from evaluation_tasksi et
		where et.grade_item_id = :grade_id
		and content_revision__is_live(et.task_id) = true
		
      </querytext>
</fullquery>

<fullquery name="update_tasks">      
      <querytext>

	update evaluation_tasks set weight=:task_weight where task_id=:task_id
	
      </querytext>
</fullquery>



</queryset>
