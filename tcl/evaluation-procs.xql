<?xml version="1.0"?>

<queryset>

<fullquery name="evaluation::get_user_portrait.user_portrait">      
      <querytext>

	select c.item_id
         from acs_rels a, cr_items c
         where a.object_id_two = c.item_id
           and a.object_id_one = :user_id
           and a.rel_type = 'user_portrait_rel'

      </querytext>
</fullquery>

<fullquery name="evaluation::clone_task.from_task_info">      
      <querytext>

	select et.task_name,
	et.number_of_members,
	et.due_date,
	et.weight,
	et.online_p,
	et.late_submit_p,
	et.requires_grade_p,
	crr.lob, crr.content, 
	crr.content_length,
	crr.title,
	crr.description,
	crr.mime_type,
	cri.storage_type
	from evaluation_tasksi et, 
	cr_revisions crr, 
	cr_items cri
	where task_id = :from_task_id 
	and et.task_id = crr.revision_id
	and cri.item_id = crr.item_id

      </querytext>
</fullquery>

<fullquery name="evaluation::clone_task.clone_content">      
      <querytext>

	update cr_revisions	
 	set content = :content,
	content_length = :content_length,
	lob = :lob
	where revision_id = :revision_id
	
      </querytext>
</fullquery>

<fullquery name="evaluation::new_task.update_item_name">      
      <querytext>

		update cr_items 
		set name = :item_name,
		storage_type = :storage_type
		where item_id = :item_id

      </querytext>
</fullquery>

<fullquery name="evaluation::new_solution.update_item_name">      
      <querytext>

		update cr_items 
		set name = :item_name,
		storage_type = :storage_type
		where item_id = :item_id

      </querytext>
</fullquery>

<fullquery name="evaluation::new_answer.update_item_name">      
      <querytext>

		update cr_items 
		set name = :item_name,
		storage_type = :storage_type
		where item_id = :item_id

      </querytext>
</fullquery>

<fullquery name="evaluation::notification::get_url.get_grade_id">      
      <querytext>

	select eg.grade_id 
	from evaluation_tasks est, evaluation_grades eg, cr_items cri
	where est.task_id = :task_id
	and est.grade_item_id = eg.grade_item_id 
	and cri.live_revision = eg.grade_id
	
      </querytext>
</fullquery>

<fullquery name="evaluation::generate_grades_sheet.get_task_info">      
      <querytext>

	select et.task_name, et.number_of_members, et.task_item_id
               from evaluation_tasks et
               where et.task_id = :task_id

      </querytext>
</fullquery>

<fullquery name="evaluation::generate_grades_sheet.parties_with_to_grade">      
      <querytext>

		$sql_query
	
      </querytext>
</fullquery>

<fullquery name="evaluation::notification::do_notification.select_names">      
      <querytext>

	select eg.grade_name, 
	et.task_name 
	from evaluation_grades eg, 
	evaluation_tasks et,
	cr_items cri 
	where et.task_id = :task_id
	and et.grade_item_id = eg.grade_item_id
	and cri.live_revision = eg.grade_id

      </querytext>
</fullquery>

<fullquery name="evaluation::public_answers_to_file_system.select_object_content">      
      <querytext>

	select lob
	from cr_revisions
	where revision_id = :revision_id

      </querytext>
</fullquery>
 
</queryset>
