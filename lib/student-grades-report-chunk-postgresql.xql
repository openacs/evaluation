<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_group_id">      
      <querytext>

		select evaluation__party_id(:student_id,:task_id)
	
      </querytext>
</fullquery>


<fullquery name="get_student_grades">      
      <querytext>

    select et.task_name, 
    et.task_item_id,
    eg.weight as grade_weight,
    et.task_id,
    et.weight as task_weight,
    (et.weight*eg.weight)/100 as task_weight,
    et.number_of_members,
    to_char(et.due_date, 'YYYY-MM-DD HH24:MI:SS') as due_date_ansi, 
    et.online_p
    from evaluation_grades eg,
    evaluation_tasks et
    where eg.grade_id = :grade_id
    and eg.grade_item_id = et.grade_item_id
    and content_revision__is_live(et.task_id) = true 
    and content_revision__is_live(eg.grade_id) = true

      </querytext>
</fullquery>

<fullquery name="group_name">      
      <querytext>

	select acs_group__name(:group_id)

      </querytext>
</fullquery>

<fullquery name="get_answer_data">      
      <querytext>
	
    select ea.answer_id 
    from evaluation_answersi ea,
	 evaluation_tasks et
    where content_revision__is_live(ea.answer_id) = true
      and ea.party_id = evaluation__party_id(:student_id,:task_id)
      and ea.task_item_id = et.task_item_id
      and et.task_id = :task_id

      </querytext>
</fullquery>

<fullquery name="get_grade_info">      
      <querytext>

	select ese.grade,
	ese.description as comments,
	(ese.grade*:task_weight*:grade_weight)/10000 as net_grade,
	person__name(ese.creation_user) as grader_name
	from evaluation_student_evalsi ese,
	evaluation_tasks et
	where ese.task_item_id = et.task_item_id
	and content_revision__is_live(ese.evaluation_id) = true
	and ese.party_id = evaluation__party_id(:student_id,:task_id)
	and et.task_id = :task_id      

      </querytext>
</fullquery>
    
</queryset>
