<?xml version="1.0"?>

<queryset>

<fullquery name="get_content_type">      
      <querytext>
	select cri.content_type
        from cr_items cri, cr_revisions crr
        where cri.item_id = crr.item_id 
 	and crr.revision_id = :revision_id
      </querytext>
</fullquery>

<fullquery name="get_folder_id">      
      <querytext>
	select crf.folder_id 
	from cr_folders crf
	where crf.label = :content_type||'_'||:package_id
      </querytext>
</fullquery>

 
</queryset>
