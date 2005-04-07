<?xml version="1.0"?>

<queryset>

<fullquery name="get_grade_info">      
      <querytext>

	select grade_name, grade_plural_name, weight as grade_weight from evaluation_grades where grade_id = :grade_id
	
      </querytext>
</fullquery>

<fullquery name="task_info">      
      <querytext>

		select et.task_name, et.description, to_char(et.due_date,'YYYY-MM-DD HH24:MI:SS') as due_date_ansi, 
		       et.weight, et.number_of_members, et.online_p, et.late_submit_p, et.requires_grade_p
		from evaluation_tasksi et
		where task_id = :task_id
	
      </querytext>
</fullquery>

</queryset>
