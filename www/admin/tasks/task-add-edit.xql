<?xml version="1.0"?>

<queryset>


<fullquery name="get_cal_id">      
      <querytext>

	    select calendar_id
	    from calendars
	    where private_p = 'f' and package_id = :community_package_id
	
      </querytext>
</fullquery>

<fullquery name="calendar_mappings">      
      <querytext>

	    select cal_item_id 
	    from evaluation_cal_task_map
	    where task_item_id = :item_id
	
      </querytext>
</fullquery>

<fullquery name="set_file_content">      
      <querytext>

		update cr_revisions
		set content = :filename,
		mime_type = :mime_type,
		content_length = :content_length
		where revision_id = :revision_id
			
      </querytext>
</fullquery>

<fullquery name="insert_cal_mapping">      
      <querytext>

		insert into evaluation_cal_task_map (
						     task_item_id,
						     cal_item_id
						     ) values 
		(
		 :item_id,
		 :cal_item_id
		 )
	    
      </querytext>
</fullquery>

</queryset>
