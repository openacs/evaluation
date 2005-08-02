<?xml version="1.0"?>

<queryset>

<fullquery name="update_task">      
      <querytext>

		update evaluation_tasks
		set weight = :aweight,points=:apoints,relative_weight=:rel_weight
		where task_id = :id
	
      </querytext>
</fullquery>

<fullquery name="update_tasks_with_grade">      
      <querytext>

		update evaluation_tasks set requires_grade_p = 't' where task_id in ([join $with_grade ,])
	
      </querytext>
</fullquery>

<fullquery name="update_tasks_without_grade">      
      <querytext>

		update evaluation_tasks set requires_grade_p = 'f' where task_id in ([join $without_grade ,])
	
      </querytext>
</fullquery>

<fullquery name="grade_info">      
      <querytext>

	select eg.grade_plural_name,
		eg.weight as grade_weight,
		eg.grade_item_id,
		eg.comments as grade_comments
		from evaluation_gradesi eg
		where grade_id = :grade_id
	
      </querytext>
</fullquery>


</queryset>
