<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_sol_info">      
      <querytext>

		select crr.filename as content, 
		crr.title,
		crr.item_id,
		cri.storage_type,
		crr.revision_id,
		crr.content_length,
		crr.mime_type
		from cr_items cri, cr_revisions crr
		where crr.revision_id = :solution_id
                and crr.item_id = cri.item_id
	
      </querytext>
</fullquery>

<fullquery name="double_click">      
      <querytext>

    select solution_id
    from evaluation_tasks_sols
    where task_item_id = :task_item_id
    and content_revision.is_live(solution_id) = 't'

      </querytext>
</fullquery>

<fullquery name="copy_content">      
      <querytext>
	begin
		content_revision.content_copy(:solution_id, :revision_id);
	end;
      </querytext>
</fullquery>

<fullquery name="lob_content">      
      <querytext>

		update cr_revisions	
	 	set content = empty_blob(),
		filename = :filename
		where revision_id = :revision_id
		returning content into :1	

      </querytext>
</fullquery>

<fullquery name="set_storage_type">      
      <querytext>

	update cr_items
 	set storage_type = 'lob'
	where item_id = :item_id

     </querytext>
</fullquery>

<fullquery name="link_content">      
      <querytext>

	update cr_revisions	
 	set filename = :url
	where revision_id = :revision_id

     </querytext>
</fullquery>

<fullquery name="set_file_content">      
      <querytext>

		update cr_revisions
		set filename = :file_name,
		mime_type = :mime_type,
		content_length = :content_length
		where revision_id = :revision_id
			
      </querytext>
</fullquery>

</queryset>
