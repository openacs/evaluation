<?xml version="1.0"?>

<queryset>


<fullquery name="task_grade_info">      
      <querytext>

	select et.task_name, eg.grade_name
	from evaluation_grades eg, evaluation_tasks et 
	where et.grade_item_id = eg.grade_item_id and et.task_id = :task_id and content_revision__is_live(eg.grade_id) = true
	
      </querytext>
</fullquery>

</queryset>
