<?xml version="1.0"?>

<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_groups">      
      <querytext>
	select count(group_id)+1 
	from evaluation_task_groups etg, evaluation_tasks et
	where et.task_id = :task_id
	and etg.task_item_id = et.task_item_id
	and content_revision.is_live(et.task_id) = 't'

      </querytext>
</fullquery>

</queryset>
