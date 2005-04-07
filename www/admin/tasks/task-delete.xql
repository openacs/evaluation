<?xml version="1.0"?>

<queryset>

<fullquery name="get_task_info">      
      <querytext>

	    select et.task_name
    	from evaluation_tasks et
		where et.task_id = :task_id
	
      </querytext>
</fullquery>

</queryset>
