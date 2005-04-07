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
		crr.content_length,
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

<fullquery name="copy_content">      
      <querytext>

		content_revision__content_copy(:solution_id, :revision_id)
	
      </querytext>
</fullquery>

<fullquery name="lob_content">      
      <querytext>

		update cr_revisions	
	 	set lob = [set __lob_id [db_string get_lob_id "select empty_lob()"]]
		where revision_id = :revision_id
	
      </querytext>
</fullquery>

<fullquery name="set_storage_type">      
      <querytext>

	update cr_items
 	set storage_type = 'text'
	where item_id = :item_id

     </querytext>
</fullquery>

<fullquery name="link_content">      
      <querytext>

				update cr_revisions	
				set content = :url
				where revision_id = :revision_id
	
      </querytext>
</fullquery>

<fullquery name="set_file_content">      
      <querytext>

		update cr_revisions
		set content = :file_name,
		mime_type = :mime_type,
		content_length = :content_length
		where revision_id = :revision_id
			
      </querytext>
</fullquery>

</queryset>
