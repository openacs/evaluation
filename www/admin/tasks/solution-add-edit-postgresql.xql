<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_sol_info">      
      <querytext>

		select content_revision__get_content(ets.solution_id) as content, 
		crr.title,
		crr.item_id,
		cri.storage_type,
		crr.revision_id,
		ets.mime_type
		from evaluation_tasks_solsi ets, cr_items cri, cr_revisions crr
		where ets.solution_id = :solution_id
		  and ets.solution_id = crr.revision_id
          and crr.item_id = cri.item_id
	
      </querytext>
</fullquery>

<fullquery name="double_click">      
      <querytext>

    select solution_id
    from evaluation_tasks_sols
    where task_item_id = :task_item_id
    and content_revision__is_live(solution_id) = true

      </querytext>
</fullquery>

<fullquery name="unassociate_task_sol">      
      <querytext>

	select evaluation__delete_task_sol(solution_id) 
	from evaluation_tasks_sols 
	where task_item_id = :task_item_id
	    	
      </querytext>
</fullquery>

<fullquery name="copy_content">      
      <querytext>

		content_revision__content_copy(:solution_id, :revision_id)
	
      </querytext>
</fullquery>

</queryset>
