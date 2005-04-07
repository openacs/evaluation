<?xml version="1.0"?>

<queryset>

<fullquery name="solution_info">      
      <querytext>

		select crr.title, crr.item_id
		from evaluation_tasks_sols ets, cr_revisions crr
		where ets.solution_id = :solution_id
          and crr.revision_id = ets.solution_id
	
      </querytext>
</fullquery>

<fullquery name="lob_size">      
      <querytext>

	update cr_revisions
 	set content_length = :content_length
	where revision_id = :revision_id

     </querytext>
</fullquery>

<fullquery name="content_size">      
      <querytext>

	update cr_revisions
 	set content_length = :content_length
	where revision_id = :revision_id

     </querytext>
</fullquery>

<fullquery name="task_info">      
      <querytext>
	
		select task_item_id
		from evaluation_tasks
		where task_id = :task_id
	
      </querytext>
</fullquery>

</queryset>
