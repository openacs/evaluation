<?xml version="1.0"?>

<queryset>

<fullquery name="lob_content">      
      <querytext>

 	update cr_revisions	
	set lob = [set __lob_id [db_string get_lob_id "select empty_lob()"]]
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
 
</queryset>
		