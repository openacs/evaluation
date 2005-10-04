<?xml version="1.0"?>

<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>


<fullquery name="get_group_id">      
      <querytext>
	select evaluation.party_id(:user_id,:task_id)
      </querytext>
</fullquery>

<fullquery name="get_evaluation_info">      
      <querytext>
	    select round(ese.grade,2) as grade,
	    ese.evaluation_id,
	    ese.description as comments,
	    ese.show_student_p,
	    round((ese.grade*:t_weight*:g_weight)/10000,2) as task_grade
	    from evaluation_student_evalsi ese, cr_items cri
	    where ese.task_item_id = :task_item_id
	    and cri.live_revision = ese.evaluation_id
	    and ese.party_id = evaluation.party_id(:user_id,:task_id)
      </querytext>
</fullquery>

<fullquery name="get_answer_info">      
      <querytext>
	    select crr.filename as answer_data, 
	    crr.title as answer_title, 
	    ea.answer_id 
	    from evaluation_answers ea, cr_items cri, cr_revisions crr
	    where ea.task_item_id = :task_item_id 
	    and cri.live_revision = ea.answer_id
		and crr.revision_id = ea.answer_id 
	    and ea.party_id = evaluation.party_id(:user_id,:task_id)
      </querytext>
</fullquery>

<fullquery name="compare_due_date">      
      <querytext>
		select 1 from dual where :due_date > sysdate
      </querytext>
</fullquery>

<fullquery name="get_tasks_admin">      
      <querytext>

	select et.task_name, 
	round(et.weight,2) as task_weight,
        et.task_id, nvl(perfect_score,0) as perfect_score, online_p
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
	round((et.weight*eg.weight)/100,2) as task_weight,
	et.number_of_members, 
	et.online_p,
	et.due_date,
	et.late_submit_p,
        et.task_id, nvl(perfect_score,0) as perfect_score
	from evaluation_grades eg,
	evaluation_tasksi et,
	cr_items cri
	where eg.grade_id = :grade_id
	and eg.grade_item_id = et.grade_item_id
	and cri.live_revision = et.task_id
	$evaluations_orderby
	
      </querytext>
</fullquery>

</queryset>
