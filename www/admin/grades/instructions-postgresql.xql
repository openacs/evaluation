<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_grade_tasks">      
      <querytext>

		select count(et.task_id) as counter
		from evaluation_tasksi et
		where et.grade_item_id = :grade_item_id
		and content_revision__is_live(et.task_id) = true
	
      </querytext>
</fullquery>

</queryset>
