<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_task_info">      
      <querytext>

		select task_name from evaluation_tasks where task_id = :task_id
	
      </querytext>
</fullquery>

</queryset>