<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_party_id">      
      <querytext>
	
		select evaluation.party_id(:user_id,:task_id) from dual
	
      </querytext>
</fullquery>

<fullquery name="double_click">      
      <querytext>

    select answer_id
    from evaluation_answers
    where party_id = :party_id
    and task_item_id = :task_item_id
    and content_revision.is_live(answer_id) = 't'

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
