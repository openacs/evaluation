<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="solution_info">      
      <querytext>

		select crr.title, crr.item_id
		from evaluation_tasks_sols ets, cr_revisions crr
		where ets.solution_id = :solution_id
          and crr.revision_id = ets.solution_id
	
      </querytext>
</fullquery>

<fullquery name="lob_content">      
      <querytext>

		update cr_revisions	
	 	set lob = [set __lob_id [db_string get_lob_id "select empty_lob()"]]
		where revision_id = :revision_id
	
      </querytext>
</fullquery>

<fullquery name="link_content">      
      <querytext>

				update cr_revisions	
				set content = :url
				where revision_id = :revision_id
	
      </querytext>
</fullquery>

<fullquery name="unassociate_task_sol">      
      <querytext>

		delete from evaluation_tasks_sols where task_id=:task_id
	
      </querytext>
</fullquery>

</queryset>
