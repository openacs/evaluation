<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_tasks_admin">      
      <querytext>

	select et.task_name, et.number_of_members, et.task_id,
		to_char(et.due_date,'YYYY-MM-DD HH24:MI:SS') as due_date_ansi, 
		et.online_p, 
		et.late_submit_p, 
		et.item_id,
		et.requires_grade_p, et.description, et.grade_item_id,
		cr.content_length,
		et.data as task_data,
		cr.title as task_title,
   		et.task_id as revision_id,
		ets.solution_id as solution_id
	from cr_revisions cr,
		 evaluation_tasksi et left outer join evaluation_tasks_solsi ets on (ets.task_item_id = et.task_item_id and content_revision__is_live(ets.solution_id) = true)
	where cr.revision_id = et.revision_id
	  and et.grade_item_id = :grade_item_id	
	  and content_revision__is_live(et.task_id) = true 
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
		et.due_date,
		et.requires_grade_p, et.description, et.grade_item_id,
		cr.title as task_title,
		et.data as task_data,
	   	et.task_id as revision_id,
		cr.content_length,
		ea.answer_id as answer_id
	from cr_revisions cr, 
		 evaluation_tasksi et left outer join evaluation_answersi ea on (ea.task_item_id = et.task_item_id and content_revision__is_live(ea.answer_id) = true
                                                                    and ea.party_id = evaluation__party_id(:user_id,et.task_id))
	where cr.revision_id = et.revision_id
	  and grade_item_id = :grade_item_id
	  and content_revision__is_live(et.task_id) = true 
    $assignments_orderby
	
      </querytext>
</fullquery>

<fullquery name="get_group_id">      
      <querytext>

		select evaluation__party_id(:user_id,:task_id)
	
      </querytext>
</fullquery>

<fullquery name="grade_names">      
      <querytext>

		select grade_name, grade_plural_name 
		from evaluation_grades 
		where grade_item_id = :grade_item_id and content_revision__is_live(grade_id) = true
	
      </querytext>
</fullquery>

</queryset>

