<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_group_id">      
      <querytext>

	select evaluation.party_id(:student_id,:task_id) from dual
	
      </querytext>
</fullquery>

<fullquery name="group_name">      
      <querytext>

	select acs_group.name(:group_id) from dual

      </querytext>
</fullquery>

<fullquery name="get_answer_data">      
      <querytext>
	
    select ea.answer_id 
    from evaluation_answers ea,
	 cr_items cri
    where cri.live_revision = ea.answer_id
      and ea.party_id = evaluation.party_id(:student_id,:task_id) 
      and ea.task_item_id = :task_item_id

      </querytext>
</fullquery>

<fullquery name="get_grade_info">      
      <querytext>

	select round(ese.grade,2) as grade,
	ese.description as comments,
	round((ese.grade*:t_weight*:g_weight)/10000,2) as net_grade,
	person.name(ese.creation_user) as grader_name
	from evaluation_student_evalsi ese,
	cr_items cri, 
	evaluation_tasks et
	where ese.task_item_id = et.task_item_id
	and et.task_id = :task_id
	and cri.live_revision = ese.evaluation_id
	and ese.party_id = evaluation.party_id(:student_id,:task_id)

      </querytext>
</fullquery>
    
</queryset>
