<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_old_grade">      
      <querytext>

		select grade from evaluation_student_evals where evaluation_id = $evaluation_ids($party_id)
	
      </querytext>
</fullquery>

<fullquery name="get_task_info">      
      <querytext>

		select task_name from evaluation_tasks where task_id = :task_id
	
      </querytext>
</fullquery>

</queryset>
