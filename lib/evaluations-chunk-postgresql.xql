<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_tasks_admin">      
      <querytext>

	select et.task_name, et.weight as task_weight,
    et.task_id
	from evaluation_tasksi et
	where grade_item_id = :grade_item_id
	  and content_revision__is_live(et.task_id) = true 
      $evaluations_orderby
	
      </querytext>
</fullquery>

<fullquery name="get_grade_tasks">      
      <querytext>

	select et.task_name, 
	ese.grade,
	ese.description as comments,
	ese.show_student_p,
	(et.weight*eg.weight)/100 as task_weight,
        (ese.grade*et.weight*eg.weight)/10000 as task_grade,
	et.number_of_members,
        et.task_id,
	ea.data as answer_data,
	ea.title as answer_title,
	ea.answer_id
	from evaluation_grades eg,
	evaluation_tasks et2 left outer join evaluation_student_evalsi ese on (ese.task_item_id = et2.task_item_id and content_revision__is_live(ese.evaluation_id) = true
                                                                    and ese.party_id = evaluation__party_id(:user_id,et2.task_id)),
	evaluation_tasks et left outer join evaluation_answersi ea on (ea.task_item_id = et.task_item_id and content_revision__is_live(ea.answer_id) = true
                                                                    and ea.party_id = evaluation__party_id(:user_id,et.task_id))
	where eg.grade_item_id = :grade_item_id
	and eg.grade_item_id = et.grade_item_id
        and et.task_id = et2.task_id
	and content_revision__is_live(et.task_id) = true 
	and content_revision__is_live(eg.grade_id) = true
	$evaluations_orderby
	
      </querytext>
</fullquery>

<fullquery name="get_group_id">      
      <querytext>

		select evaluation__party_id(:user_id,:task_id)
	
      </querytext>
</fullquery>

</queryset>
