<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_task_info">      
      <querytext>

		select et.task_name, et.number_of_members, 
               et.due_date, et.weight, et.online_p,
               et.late_submit_p, et.requires_grade_p,
               et.description,
               et.title as task_title,
               et.data as task_data,
	       et.revision_id as task_revision_id,
               ets.title as solution_title,
               ets.data as solution_data,
               eg.grade_plural_name, eg.weight as grade_weight,
	       ets.revision_id as solution_revision_id
        from evaluation_grades eg,
	evaluation_tasksi et left outer join evaluation_tasks_solsi ets on (ets.task_id = et.task_id and content_revision__is_live(ets.solution_id) = true) 
        where et.task_id = :task_id
          and et.grade_id = eg.grade_id
	
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