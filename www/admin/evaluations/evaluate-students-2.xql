<?xml version="1.0"?>

<queryset>

<fullquery name="lob_size">      
      <querytext>

	update cr_revisions
	set content_length = :content_length
	where revision_id = :revision_id

      </querytext>
</fullquery>

<fullquery name="task_info">      
      <querytext>
	
		select task_item_id,perfect_score
		from evaluation_tasks
		where task_id = :task_id
	
      </querytext>
</fullquery>
 
</queryset>
		