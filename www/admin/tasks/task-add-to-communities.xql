<?xml version="1.0"?>

<queryset>


<fullquery name="task_grade_info">      
      <querytext>

	select et.task_name, eg.grade_name from evaluation_grades eg, evaluation_tasks et where et.grade_id = eg.grade_id and et.task_id = :task_id
	
      </querytext>
</fullquery>

</queryset>
