<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="evaluated_students">      
      <querytext>

	select evaluation__party_name(ese.party_id,et.task_id) as party_name,
	ese.party_id,
	ese.grade,
	ese.last_modified as evaluation_date,
	et.online_p,
	et.due_date,
	ese.evaluation_id
	from evaluation_tasks et,
	     evaluation_student_evalsi ese 
	where et.task_id = :task_id
	  and et.task_item_id = ese.task_item_id
	  and content_revision__is_live(ese.evaluation_id) = true
        $orderby       
	
      </querytext>
</fullquery>

<fullquery name="get_not_eval_wa">      
      <querytext>

		select count(party_id) from evaluation_answers ea where ea.task_item_id = :task_item_id $processed_clause and content_revision__is_live(ea.answer_id) = true
	
      </querytext>
</fullquery>

<fullquery name="compare_evaluation_date">      
      <querytext>

	select 1 from dual where :submission_date > :evaluation_date
	
      </querytext>
</fullquery>

<fullquery name="compare_submission_date">      
      <querytext>

	select 1 from dual where :submission_date > :due_date
	
      </querytext>
</fullquery>

<fullquery name="get_answer_info">      
      <querytext>

	    select ea.data as answer_data,
	    ea.title as answer_title,
	    ea.revision_id,
	    to_char(ea.creation_date, 'YYYY-MM-DD HH24:MI:SS') as submission_date_ansi,
	    ea.last_modified as submission_date
	    from evaluation_answersi ea 
            where ea.party_id = :party_id 
	    and ea.task_item_id = :task_item_id
	    and content_revision__is_live(ea.answer_id) = true
	
      </querytext>
</fullquery>

<fullquery name="count_evaluated_students">      
      <querytext>

		select count(*) 
		from evaluation_student_evals ese, evaluation_tasks et 
		where ese.task_item_id = et.task_item_id
		and et.task_id = :task_id 
		and content_revision__is_live(ese.evaluation_id) = true
	
      </querytext>
</fullquery>

<partialquery name="processed_clause">
	  <querytext>         

		and ea.party_id not in ([join $done_students ","]) 

	  </querytext>
</partialquery>

<fullquery name="get_not_evaluated_wa_students">      
      <querytext>

	select evaluation__party_name(ea.party_id, :task_id) as party_name,
        ea.party_id,
	ea.data as answer_data,
	ea.title as answer_title,
	ea.revision_id,
	to_char(ea.last_modified, 'YYYY-MM-DD HH24:MI:SS') as submission_date_ansi,
	et.due_date,
	ea.last_modified as submission_date
	from evaluation_answersi ea, 
	     evaluation_tasks et,
	     cr_items cri
	where ea.task_item_id = et.task_item_id
          and et.task_id = :task_id
          and ea.data is not null
          and cri.live_revision = ea.answer_id
        $processed_clause
	
      </querytext>
</fullquery>

<fullquery name="get_task_info">      
      <querytext>

	select et.task_name,
		et.task_item_id,
		eg.grade_id,
		eg.grade_plural_name,
		eg.weight as grade_weight,
		et.weight as task_weight,
		to_char(et.due_date, 'YYYY-MM-DD HH24:MI:SS') as due_date_ansi,
		et.number_of_members,
		et.online_p
		from evaluation_grades eg, evaluation_tasks et
		where et.task_id = :task_id
		  and et.grade_item_id = eg.grade_item_id
		  and content_revision__is_live(eg.grade_id) = true
	
      </querytext>
</fullquery>

<partialquery name="sql_query_groups">
	  <querytext>         
		select acs_group__name(etg.group_id) as party_name,
		etg.group_id as party_id
		from evaluation_task_groups etg, evaluation_tasks et
        where etg.task_item_id = et.task_item_id
		and et.task_id = :task_id
		$not_in_clause
		$orderby_na
	  </querytext>
</partialquery>

</queryset>
