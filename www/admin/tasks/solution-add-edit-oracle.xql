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
	 	set lob = [set __lob_id [db_string get_lob_id "select empty_lob() from dual"]]
		where revision_id = :revision_id
	
      </querytext>
</fullquery>

<fullquery name="link_content">      
      <querytext>

	update cr_revisions	
 	set filename = :url
	where revision_id = :revision_id

     </querytext>
</fullquery>

</queryset>
