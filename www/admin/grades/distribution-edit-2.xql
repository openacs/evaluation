<?xml version="1.0"?>

<queryset>

<fullquery name="update_task">      
      <querytext>

		update evaluation_tasks
		set weight = :aweight
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

</queryset>
