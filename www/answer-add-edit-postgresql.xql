<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_party_id">      
      <querytext>
	
		select evaluation__party_id(:user_id,:task_id)	
	
      </querytext>
</fullquery>

<fullquery name="double_click">      
      <querytext>

    select answer_id
    from evaluation_answers
    where party_id = :party_id
    and task_item_id = :task_item_id
    and content_revision__is_live(answer_id) = true

      </querytext>
</fullquery>

<fullquery name="compare_dates">      
      <querytext>
	
	select 1 from evaluation_tasks  where task_id = :task_id and due_date < now()
	
      </querytext>
</fullquery>

<fullquery name="lob_content">      
      <querytext>
	
		update cr_revisions	
 		set lob = [set __lob_id [db_string get_lob_id "select empty_lob()"]]
		where revision_id = :revision_id
 	
      </querytext>
</fullquery>

<fullquery name="set_storage_type">      
      <querytext>

	update cr_items
 	set storage_type = 'text'
	where item_id = :item_id

     </querytext>
</fullquery>

<fullquery name="link_content">      
      <querytext>
	
		update cr_revisions	
		set content = :url
		where revision_id = :revision_id

      </querytext>
</fullquery>

<fullquery name="set_file_content">      
      <querytext>

		update cr_revisions
		set content = :file_name,
		mime_type = :mime_type,
		content_length = :content_length
		where revision_id = :revision_id
			
      </querytext>
</fullquery>

</queryset>
