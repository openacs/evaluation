<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_groups">      
      <querytext>
	select count(group_id)+1 
	from evaluation_task_groups etg, evaluation_tasks et
	where et.task_id = :task_id
	and etg.task_item_id = et.task_item_id
	and content_revision__is_live(et.task_id) = true

      </querytext>
</fullquery>

</queryset>
