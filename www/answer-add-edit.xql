<?xml version="1.0"?>

<queryset>

<fullquery name="set_file_content">      
      <querytext>

		update cr_revisions
		set content = :filename,
		mime_type = :mime_type,
		content_length = :content_length
		where revision_id = :revision_id
			
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

</queryset>
