<?xml version="1.0"?>

<queryset>

<fullquery name="get_grade_info">      
      <querytext>

		select grade_plural_name, 
		grade_name, 
		weight as grade_weight,
		grade_item_id
		 from evaluation_grades where grade_id = :grade_id

      </querytext>
</fullquery>

<fullquery name="task_info">      
      <querytext>

		select et.task_name, et.description, to_char(et.due_date,'YYYY-MM-DD HH24:MI:SS') as due_date_ansi, 
		       et.weight, et.number_of_members, et.online_p, et.late_submit_p, et.requires_grade_p
		from evaluation_tasksi et
		where task_id = :task_id
	
      </querytext>
</fullquery>

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
