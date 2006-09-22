<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_task_info">      
      <querytext>

		select crr.filename as content,
		crr.title,
		crr.content_length,
        	crr.item_id,
		crr.mime_type,
		cri.storage_type
		from cr_revisions crr, cr_items cri
		where crr.revision_id = :task_id
          and crr.item_id = cri.item_id
	
      </querytext>
</fullquery>

<fullquery name="set_date">      
      <querytext>
 	  select to_date('[template::util::date::get_property linear_date $due_date]','YYYY-MM-DD HH24:MI:SS') from dual
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

<fullquery name="copy_content">      
      <querytext>
	begin
	 content_revision.content_copy (:task_id, :revision_id);
	end;
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

<fullquery name="get_user_comunities">      
      <querytext>

    	select count(*)
    	from dotlrn_communities_all,
    	dotlrn_member_rels_approved,
    	dotlrn_classes
    	where dotlrn_communities_all.community_id = dotlrn_member_rels_approved.community_id
    	and dotlrn_communities_all.community_type = dotlrn_classes.class_key
    	and dotlrn_member_rels_approved.user_id = :user_id
    	and acs_permission.permission_p(dotlrn_communities_all.community_id, :user_id, 'admin') = 't'
	and dotlrn_communities_all.community_id <> [dotlrn_community::get_community_id]
	
      </querytext>
</fullquery>

<fullquery name="update_date">      
      <querytext>

	    update evaluation_tasks set due_date = (select to_date(:due_date,'YYYY-MM-DD HH24:MI:SS') from dual)
	    where task_id = :revision_id

     </querytext>
</fullquery>

</queryset>


