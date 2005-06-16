<?xml version="1.0"?>

<queryset>

<fullquery name="get_grade_info">      
      <querytext>

		select eg.grade_plural_name, (select count(et.task_id) from evaluation_tasks et, cr_items cri where
	        et.grade_item_id = eg.grade_item_id and et.task_id=cri.live_revision) as tasks_counter,
		eg.grade_name, 
		eg.weight as grade_weight,
		eg.grade_item_id
		from evaluation_grades eg
		where eg.grade_id = :grade_id
	
      </querytext>
</fullquery>

<fullquery name="select_grade_types">      
      <querytext>
	select eg.grade_name, eg.grade_item_id 
		from evaluation_grades eg, acs_objects ao, cr_items cri
		where cri.live_revision = eg.grade_id
		and eg.grade_item_id = ao.object_id
		and ao.context_id = :package_id
		order by eg.grade_plural_name desc

      </querytext>
</fullquery>
	    
<fullquery name="update_points">      

      <querytext>
	update evaluation_tasks set points=:points,perfect_score=:perfect_score,relative_weight=:relative_weight,forums_related_p=:forums_related_p where task_id=:revision_id

      </querytext>
</fullquery>

<fullquery name="get_grade_tasks">      
      <querytext>
		select * from evaluation_tasks et where
	        et.grade_item_id = :grade_item_id and et.task_id=(select live_revision from cr_items where item_id=et.task_item_id) 
      </querytext>
</fullquery>
<fullquery name="update_tasks">      
      <querytext>
	update evaluation_tasks set relative_weight=:relative_weight where task_id=:task_id
      </querytext>
</fullquery>

<fullquery name="task_info">      
      <querytext>

		select et.task_name, et.description, to_char(et.due_date,'YYYY-MM-DD HH24:MI:SS') as due_date_ansi, 
		       et.weight, et.number_of_members, et.online_p, et.late_submit_p, et.requires_grade_p,(select points from evaluation_tasks where task_id=:task_id) as points,(select perfect_score from evaluation_tasks where task_id=:task_id)  as perfect_score,(select forums_related_p from evaluation_tasks where task_id=:task_id) as forums_related_p
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
