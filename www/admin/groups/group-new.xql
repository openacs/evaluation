<?xml version="1.0"?>

<queryset>

<fullquery name="get_groups">      
      <querytext>
	select count(group_id)+1 
	from evaluation_task_groups etg, evaluation_tasks et
	where et.task_id = :task_id
	and etg.task_item_id = et.task_item_id
	and content_revision__is_live(et.task_id) = true

      </querytext>
</fullquery>

<fullquery name="get_student_name">      
      <querytext>

		select last_name ||', '|| first_names from persons where person_id=:student_id

      </querytext>
</fullquery>

</queryset>
