<?xml version="1.0"?>

<queryset>

<fullquery name="get_task_info">      
      <querytext>

	select task_name, task_item_id 
	from evaluation_tasks where task_id = :task_id
	
      </querytext>
</fullquery>

</queryset>
