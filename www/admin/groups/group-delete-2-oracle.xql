<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="delete_group">      
      <querytext>

 	begin
			:1 := evaluation.delete_evaluation_task_group (:evaluation_group_id);
	end;
	
      </querytext>
</fullquery>

</queryset>
