<?xml version="1.0"?>

<queryset>

<fullquery name="grade_names">      
      <querytext>
		select eg.grade_name, eg.grade_plural_name 
		from evaluation_grades eg, cr_items cri
		where eg.grade_item_id = :grade_item_id 
		and cri.live_revision = eg.grade_id
      </querytext>
</fullquery>

<fullquery name="solution_info">      
      <querytext>
	    select ets.solution_id
	    from evaluation_tasks_sols ets, cr_items cri
	    where ets.task_item_id = :task_item_id
	    and cri.live_revision = ets.solution_id
      </querytext>
</fullquery>

<fullquery name="get_tasks_admin">      
      <querytext>

	select et.task_name, et.number_of_members, et.task_id,
		to_char(et.due_date,'YYYY-MM-DD HH24:MI:SS') as due_date_ansi, 
		et.online_p, 
		et.late_submit_p, 
		et.task_item_id,
		et.item_id,
		et.requires_grade_p, et.description, et.grade_item_id,
		coalesce(round(cr.content_length/1024,0),0) as content_length,
		et.data as task_data,
		crmt.label as pretty_mime_type,
		cr.title as task_title,
   		et.task_id as revision_id
	from cr_revisions cr,
	     evaluation_tasksi et,
	     cr_items cri,
	     cr_mime_types crmt	
	where cr.revision_id = et.revision_id
	  and et.grade_item_id = :grade_item_id	
	  and cri.live_revision = et.task_id
	  and et.mime_type = crmt.mime_type
	$assignments_orderby

      </querytext>
</fullquery>

<fullquery name="get_tasks">      
      <querytext>

	select et.task_name, et.number_of_members, et.task_id,
		to_char(et.due_date,'YYYY-MM-DD HH24:MI:SS') as due_date_ansi, 
		et.online_p, 
		et.late_submit_p, 
		et.item_id,
		et.task_item_id,
		et.due_date,
		et.requires_grade_p, et.description, et.grade_item_id,
		cr.title as task_title,
		et.data as task_data,
	   	et.task_id as revision_id,
		coalesce(round(cr.content_length/1024,0),0) as content_length,
		et.late_submit_p,
		crmt.label as pretty_mime_type
	from cr_revisions cr, 
		 evaluation_tasksi et,
	         cr_items cri,
		 cr_mime_types crmt
	where cr.revision_id = et.revision_id
	  and grade_item_id = :grade_item_id
	  and cri.live_revision = et.task_id
	  and et.mime_type = crmt.mime_type
    $assignments_orderby
	
      </querytext>
</fullquery>

<fullquery name="compare_due_date">      
      <querytext>

	select 1 from dual where :due_date > current_timestamp
	
      </querytext>
</fullquery>

<fullquery name="get_group_id">      
      <querytext>

	select coalesce((select etg2.group_id from evaluation_task_groups etg2, 
                                                      evaluation_tasks et2, 
                                                      acs_rels map 
                                                      where map.object_id_one = etg2.group_id 
                                                        and map.object_id_two = :user_id 
                                                        and etg2.task_item_id = et2.task_item_id 
                                                        and et2.task_id = :task_id),0)
               from evaluation_tasks et3 
              where et3.task_id = :task_id 
	
      </querytext>
</fullquery>

<fullquery name="answer_info">      
      <querytext>

      select ea.answer_id
      from evaluation_answers ea, cr_items cri
      where ea.task_item_id = :task_item_id 
      and cri.live_revision = ea.answer_id
      and ea.party_id = 
	( select 
	CASE  
	  WHEN et3.number_of_members = 1 THEN :user_id 
	  ELSE  
	(select etg2.group_id from evaluation_task_groups etg2, 
                                                      evaluation_tasks et2, 
                                                      acs_rels map 
                                                      where map.object_id_one = etg2.group_id 
                                                        and map.object_id_two = :user_id 
                                                        and etg2.task_item_id = et2.task_item_id 
                                                        and et2.task_id = :task_id) 
	END as nom 
               from evaluation_tasks et3 
              where et3.task_id = :task_id 
	) 
      
      </querytext>
</fullquery>


</queryset>
