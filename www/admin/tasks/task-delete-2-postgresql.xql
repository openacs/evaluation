<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="delete_task">      
      <querytext>

		select evaluation__delete_task (
									  :task_id
								  );
	
      </querytext>
</fullquery>

</queryset>
