<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="delete_group">      
      <querytext>

			select evaluation__delete_evaluation_task_group (
															 :evaluation_group_id
															 );

	
      </querytext>
</fullquery>

</queryset>
