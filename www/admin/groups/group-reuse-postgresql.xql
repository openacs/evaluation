<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_groups">      
      <querytext>

	select et.task_name, et.number_of_members,
    et.task_id as from_task_id,
    eg.grade_plural_name
	from evaluation_tasksi et, evaluation_gradesi eg
	where content_revision__is_live(et.task_id) = true 
      and et.number_of_members > 1
      and et.grade_item_id = eg.grade_item_id
      and content_revision__is_live(eg.grade_id) = true 
      and content_revision__is_live(et.task_id) = true
      and et.task_id <> :task_id
      $orderby
	
      </querytext>
</fullquery>

</queryset>
