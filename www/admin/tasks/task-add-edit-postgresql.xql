<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_grade_info">      
      <querytext>

		select grade_plural_name, weight as grade_weight from evaluation_grades where grade_id = :grade_id
	
      </querytext>
</fullquery>

<fullquery name="get_task_info">      
      <querytext>

		select content_revision__get_content(et.revision_id) as content, 
		et.title,
        et.item_id,
		cri.storage_type
		from evaluation_tasksi et, cr_items cri
		where et.task_id = :task_id
          and et.item_id = cri.item_id
	
      </querytext>
</fullquery>

<fullquery name="task_info">      
      <querytext>

		select et.task_name, et.description, to_char(et.due_date,'YYYY-MM-DD HH24:MI:SS') as due_date, 
		       et.weight, et.number_of_members, et.online_p, et.late_submit_p, et.requires_grade_p
		from evaluation_tasksi et
		where task_id = :task_id
	
      </querytext>
</fullquery>

<fullquery name="set_date">      
      <querytext>

		select [template::util::date::get_property sql_date $due_date] from dual
	
      </querytext>
</fullquery>

<fullquery name="lob_content">      
      <querytext>

		update cr_revisions	
 		set lob = [set __lob_id [db_string get_lob_id "select empty_lob()"]]
		where revision_id = :revision_id

     </querytext>
</fullquery>

<fullquery name="link_content">      
      <querytext>

	update cr_revisions	
 	set content = :url
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

<fullquery name="copy_content">      
      <querytext>

		content_revision__content_copy(:task_id, :revision_id)

     </querytext>
</fullquery>

</queryset>


