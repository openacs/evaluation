<?xml version="1.0"?>

<queryset>

<fullquery name="revision_info">      
      <querytext>
	select cri.content_type, cri.name
        from cr_items cri, cr_revisions crr
        where cri.item_id = crr.item_id 
 	and crr.revision_id = :revision_id
      </querytext>
</fullquery>
</queryset>
