<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_sol_info">      
      <querytext>

		select content_revision__get_content(ets.solution_id) as content, 
		crr.title,
		crr.item_id,
		cri.storage_type,
		crr.revision_id
		from evaluation_tasks_sols ets, cr_items cri, cr_revisions crr
		where ets.solution_id = :solution_id
		  and ets.solution_id = crr.revision_id
          and crr.item_id = cri.item_id
	
      </querytext>
</fullquery>

<fullquery name="copy_content">      
      <querytext>

		content_revision__content_copy(:solution_id, :revision_id)
	
      </querytext>
</fullquery>

</queryset>
