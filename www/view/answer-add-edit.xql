<?xml version="1.0"?>

<queryset>

<fullquery name="compare_dates">      
      <querytext>
	
	select 1 from evaluation_tasks  where task_id = :task_id and due_date < current_timestamp
	
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

<fullquery name="task_info">      
      <querytext>
	
		select task_item_id, task_name
		from evaluation_tasks
		where task_id = :task_id
	
      </querytext>
</fullquery>

<fullquery name="late_turn_in">      
      <querytext>
	
	select late_submit_p from evaluation_tasks where task_id = :task_id
	
      </querytext>
</fullquery>

<fullquery name="item_data">      
      <querytext>
	
		select crr.title, crr.item_id
		from evaluation_answers ea, cr_revisions crr
		where ea.answer_id = :answer_id
          and crr.revision_id = ea.answer_id
	
      </querytext>
</fullquery>

</queryset>
