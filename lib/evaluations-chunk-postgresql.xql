<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_tasks_admin">      
      <querytext>

	select et.task_name, et.weight as task_weight,
    et.task_id
	from evaluation_tasksi et, cr_items cri
	where grade_item_id = :grade_item_id
	  and cri.live_revision = et.task_id
      $evaluations_orderby
	
      </querytext>
</fullquery>

<fullquery name="get_grade_tasks">      
      <querytext>

	select et.task_name, 
	et.task_item_id,
	et.weight as t_weight,
	eg.weight as g_weight,
	(et.weight*eg.weight)/100 as task_weight,
	et.number_of_members,
        et.task_id
	from evaluation_grades eg,
	evaluation_tasksi et,
	cr_items cri
	where eg.grade_id = :grade_id
	and eg.grade_item_id = et.grade_item_id
	and cri.live_revision = et.task_id
	$evaluations_orderby
		
      </querytext>
</fullquery>

<fullquery name="get_group_id">      
      <querytext>

		select evaluation__party_id(:user_id,:task_id)
	
      </querytext>
</fullquery>

<fullquery name="get_evaluaiton_info">      
      <querytext>

	    select ese.grade,
	    ese.description as comments,
	    ese.show_student_p,
	    (ese.grade*:t_weight*:g_weight)/10000 as task_grade
	    from evaluation_student_evalsi ese, cr_items cri
	    where ese.task_item_id = :task_item_id
	    and cri.live_revision = ese.evaluation_id
	    and ese.party_id = evaluation__party_id(:user_id,:task_id)

      </querytext>
</fullquery>

<fullquery name="get_answer_info">      
      <querytext>

	    select ea.data as answer_data, 
	    ea.title as answer_title, 
	    ea.answer_id 
	    from evaluation_answersi ea, cr_items cri
	    where ea.task_item_id = :task_item_id 
	    and cri.live_revision = ea.answer_id
	    and ea.party_id = evaluation__party_id(:user_id,:task_id)

      </querytext>
</fullquery>

</queryset>
