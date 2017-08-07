<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

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
	evaluation_tasksi et left join evaluation_tasks_solsi ets on (ets.task_item_id = et.task_item_id and content_revision.is_live(ets.solution_id) = 't') 
        where et.task_id = :task_id
          and et.grade_item_id = eg.grade_item_id
	  and content_revision.is_live(eg.grade_id) = 't'
	
      </querytext>
</fullquery>

</queryset>
