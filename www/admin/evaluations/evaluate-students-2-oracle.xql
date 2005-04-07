<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="grades_wa_new">      
      <querytext>

	select count(*) 
	from evaluation_student_evals ese, evaluation_tasks est 
	where ese.party_id = :party_id 
	and ese.task_item_id = :task_item_id 
	and content_revision.is_live(ese.evaluation_id) = 't'
	and est.task_id = :task_id and est.task_item_id = ese.task_item_id

      </querytext>
</fullquery>

<fullquery name="grades_na_new">      
      <querytext>

	select count(*) 
	from evaluation_student_evals ese, evaluation_tasks est 
	where ese.party_id = :party_id 
	and ese.task_item_id = :task_item_id 
	and content_revision.is_live(ese.evaluation_id) = 't' 
	and ese.task_item_id = est.task_item_id and est.task_id = :task_id

      </querytext>
</fullquery>

<fullquery name="">      
      <querytext>

      </querytext>
</fullquery>

<fullquery name="lob_content">      
      <querytext>

		update cr_revisions	
 		set content = empty_blob(),
		filename = :tmp_filename
		where revision_id = :revision_id
		returning content into :1

     </querytext>
</fullquery>

<fullquery name="set_file_content">      
      <querytext>

		update cr_revisions
		set filename = :file_name,
		mime_type = :mime_type,
		content_length = :content_length
		where revision_id = :revision_id
			
      </querytext>
</fullquery>

</queryset>
