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
	    select ea.data as answer_data, 
	    ea.title as answer_title, 
	    ea.answer_id 
	    from evaluation_answersi ea, cr_items cri
	    where ea.task_item_id = :task_item_id 
	    and cri.live_revision = ea.answer_id
	    and ea.party_id = evaluation.party_id(:user_id,:task_id)
      </querytext>
</fullquery>

</queryset>
