<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_tasks_admin">      
      <querytext>

	select et.task_name, et.number_of_members, et.task_id,
		to_char(et.due_date, 'YYYY-MM-DD HH24:MI:SS') as due_date_ansi, 
		et.online_p, 
		et.late_submit_p, 
		et.item_id,
		et.requires_grade_p, et.description, et.grade_id,
		cr.content_length,
		et.data as task_data,
		et.title as task_title,
   		et.task_id as revision_id,
		ets.solution_id as solution_id
	from cr_revisions cr, 
		 evaluation_tasksi et left outer join evaluation_tasks_solsi ets on (ets.task_id = et.task_id and content_revision__is_live(ets.solution_id) = true)
	where cr.revision_id = et.revision_id
	  and grade_id = :grade_id	
	  and content_revision__is_live(et.task_id) = true 
	$assignments_orderby

      </querytext>
</fullquery>

<fullquery name="get_tasks">      
      <querytext>

	select et.task_name, et.number_of_members, et.task_id,
		to_char(et.due_date, 'YYYY-MM-DD HH24:MI:SS') as due_date_ansi, 
`		et.online_p, 
		et.late_submit_p, 
		et.item_id,
		et.due_date,
		et.requires_grade_p, 
		et.description, 
		et.grade_id,
		et.title as task_title,
		et.data as task_data,
	   	et.task_id as revision_id,
		cr.content_length,
		ea.answer_id as answer_id
	from cr_revisions cr, 
		 evaluation_tasksi et left outer join evaluation_answersi ea on (ea.task_id = et.task_id and content_revision__is_live(ea.answer_id) = true
                                                                    and ea.party_id = evaluation__party_id(:user_id,et.task_id))
	where cr.revision_id = et.revision_id
	  and grade_id = :grade_id
	  and content_revision__is_live(et.task_id) = true 
    $assignments_orderby
	
      </querytext>
</fullquery>

<fullquery name="get_group_id">      
      <querytext>

		select evaluation__party_id(:student_id,:task_id)
	
      </querytext>
</fullquery>


<fullquery name="get_student_grades">      
      <querytext>

    select et.task_name, 
    ese.grade,
    ese.description as comments,
    (et.weight*eg.weight)/100 as task_weight,
    (ese.grade*et.weight*eg.weight)/10000 as net_grade,
    et.number_of_members,
    to_char(et.due_date, 'YYYY-MM-DD HH24:MI:SS') as due_date_ansi, 
    et.task_id,
    et.online_p,
    ea.answer_id,
    person__name(ese.creation_user) as grader_name
    from evaluation_grades eg,
    evaluation_tasks et2 left outer join evaluation_student_evalsi ese on (ese.task_id = et2.task_id and content_revision__is_live(ese.evaluation_id) = true
									   and ese.party_id = evaluation__party_id(:student_id,et2.task_id)),
    evaluation_tasks et left outer join evaluation_answersi ea on (ea.task_id = et.task_id and content_revision__is_live(ea.answer_id) = true
								   and ea.party_id = evaluation__party_id(:student_id,et.task_id))
    where eg.grade_id = :grade_id
    and eg.grade_id = et.grade_id
    and et.task_id = et2.task_id
    and content_revision__is_live(et.task_id) = true 
    and content_revision__is_live(eg.grade_id) = true

      </querytext>
</fullquery>

<fullquery name="group_name">      
      <querytext>

	select acs_group__name(:group_id)

      </querytext>
</fullquery>

</queryset>
