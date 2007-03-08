<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="evaluation::delete_evaluation_group.delete_evaluation_group">      
      <querytext>

	   	select evaluation__delete_evaluation_task_group (:group_id)

      </querytext>
</fullquery>

<fullquery name="evaluation::new_evaluation_group.evaluation_group_new">      
      <querytext>

		select evaluation__new_evaluation_task_group (
													  :group_id,
													  :group_name,
													  'closed',
													  :creation_date,
													  :creation_user,
													  :creation_ip,
													  :context,
													  :task_item_id
													  );

      </querytext>
</fullquery>

<fullquery name="evaluation::evaluation_group_name.evaluation_group_name">      
      <querytext>

		select acs_group__name(:group_id) as group_name

      </querytext>
</fullquery>

<partialquery name="evaluation::generate_grades_sheet.sql_query_individual">      
      <querytext>

	select cu.person_id as party_id, cu.last_name||' - '||cu.first_names as party_name,  
               round(ese.grade,2) as grade,
               ese.description as comments
         from cc_users cu left outer join evaluation_student_evalsi ese on (ese.party_id = cu.person_id
                                                                            and ese.task_item_id = :task_item_id
                                                                            and content_revision__is_live(ese.evaluation_id) = true)
	
      </querytext>
</partialquery>

<partialquery name="evaluation::generate_grades_sheet.sql_qyery_comm_ind">      
      <querytext>

	select p.person_id as party_id, p.last_name||' - '||p.first_names as party_name,  
               ese.grade,
               ese.description as comments
         from registered_users ru, 
	      dotlrn_member_rels_approved app,
	      persons p left outer join evaluation_student_evalsi ese on (ese.party_id = p.person_id
                                                                            and ese.task_item_id = :task_item_id
                                                                            and content_revision__is_live(ese.evaluation_id) = true)
	 where app.community_id = :community_id 
                and app.user_id = ru.user_id 
                and app.user_id = p.person_id 
                and app.role = 'student'
		
      </querytext>
</partialquery>

<partialquery name="evaluation::generate_grades_sheet.sql_query_groups">      
      <querytext>

	select etg.group_id as party_id, 
		g.group_name as party_name,  
                grade,
                ese.description as comments
         from groups g,
              evaluation_task_groups etg left outer join evaluation_student_evalsi ese on (ese.party_id = etg.group_id
                                                                                           and ese.task_item_id = :task_item_id
                                                                                          and content_revision__is_live(ese.evaluation_id) = true)
         where etg.task_item_id = :task_item_id
               and etg.group_id = g.group_id
	
      </querytext>
</partialquery>

<fullquery name="evaluation::notification::do_notification.get_eval_info">      
      <querytext>

	select description as edit_reason, 
	grade as current_grade,
	evaluation__party_name(party_id,:task_id) as party_name
	from evaluation_student_evalsi
	where evaluation_id = :evaluation_id
	
      </querytext>
</fullquery>

<fullquery name="evaluation::public_answers_to_file_system.get_answers_for_task">      
      <querytext>

	select evaluation__party_name(ea.party_id, et.task_id) as party_name,
	crr.title as answer_title,
	crr.revision_id,
	crr.content as cr_file_name,
	cri.storage_type,
	cri.storage_area_key as cr_path
	from evaluation_answersi ea, 
	cr_revisions crr,
	evaluation_tasks et,
	cr_items cri,
	cr_items cri2
	where ea.task_item_id = et.task_item_id
	and ea.answer_item_id = cri.item_id
	and crr.revision_id = ea.answer_id
	and et.task_id = :task_id
	and ea.data is not null
	and cri2.live_revision = ea.answer_id
	and not exists (select 1 from evaluation_student_evals ese, cr_items cri3 where ese.party_id = ea.party_id and ese.task_item_id = et.task_item_id and cri3.live_revision = ese.evaluation_id)

      </querytext>
</fullquery>

<fullquery name="evaluation::public_answers_to_file_system.url">      
      <querytext>

	select content_revision__get_content(:revision_id) 

      </querytext>
</fullquery>

<fullquery name="evaluation::new_grade.get_date">
      <querytext>
  
        select now()

      </querytext>
</fullquery>

<fullquery name="evaluation::new_evaluation.get_date">
      <querytext>

        select now()

      </querytext>
</fullquery>

<fullquery name="evaluation::new_evaluation_group.get_date">
      <querytext>

        select now()

      </querytext>
</fullquery>

<fullquery name="evaluation::new_answer.get_date">
      <querytext>

        select now()

      </querytext>
</fullquery>

<fullquery name="evaluation::new_grades_sheet.get_date">
      <querytext>

        select now()

      </querytext>
</fullquery>

<fullquery name="evaluation::new_solution.get_date">
      <querytext>

        select now()

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
	et.estimated_time,
        et.points,
        et.perfect_score,
        et.relative_weight,
        et.forums_related_p,
	crr.lob, 
	crr.content, 
	crr.content_length,
	crr.title,
	crr.description,
	crr.mime_type,
	cri.storage_type,
	cri.content_type
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

	select evaluation__clone_task(:from_task_id,:revision_id)
		
      </querytext>
</fullquery>
 
</queryset>
