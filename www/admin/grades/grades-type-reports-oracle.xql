<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_tasks">      
      <querytext>

	select count(task_id) 
	from evaluation_tasks et, evaluation_grades eg 
	where eg.grade_id = :grade_id 
	and content_revision.is_live(eg.grade_id) = 't' 
	and eg.grade_item_id = et.grade_item_id

      </querytext>
</fullquery>

<partialquery name="task_grade">
	  <querytext>         

	, round(evaluation.task_grade(cu.user_id,$task_id),2) as task_$task_id

	  </querytext>
</partialquery>

<partialquery name="grade_total_grade">
	  <querytext>         

	, round(evaluation.grade_total_grade(cu.user_id,:grade_id),2) as total_grade

	  </querytext>
</partialquery>


</queryset>
