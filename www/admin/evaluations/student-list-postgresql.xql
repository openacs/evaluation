<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="evaluated_students">      
      <querytext>

	select evaluation__party_name(ese.party_id,et.task_id) as party_name,
	ea.data as answer_data,
	ea.title as answer_title,
	ea.revision_id,
	ese.party_id,
	ese.grade,
	to_char(ea.last_modified, 'MM-DD-YYYY HH24:MI:SS') as pretty_submission_date,
	ea.last_modified as submission_date,
	ese.last_modified as evaluation_date,
	et.online_p,
	et.due_date,
	ese.evaluation_id
	from evaluation_tasks et,
	     evaluation_student_evalsi ese left outer join evaluation_answersi ea on (ea.party_id = ese.party_id 
																				  and ea.task_id = ese.task_id
																				  and content_revision__is_live(ea.answer_id) = true)
	where et.task_id = :task_id
	  and et.task_id = ese.task_id
	  and content_revision__is_live(ese.evaluation_id) = true
	
      </querytext>
</fullquery>

<fullquery name="get_not_eval_wa">      
      <querytext>

		select count(party_id) from evaluation_answers ea where ea.task_id = :task_id $processed_clause and content_revision__is_live(ea.answer_id) = true
	
      </querytext>
</fullquery>

<partialquery name="processed_clause">
	  <querytext>         

		and ea.party_id not in ([join $done_students ","]) 

	  </querytext>
</partialquery>

<fullquery name="get_not_evaluated_wa_students">      
      <querytext>

	select evaluation__party_name(ea.party_id, ea.task_id) as party_name,
    ea.party_id,
	ea.data as answer_data,
	ea.title as answer_title,
	ea.revision_id,
	to_char(ea.last_modified, 'MM-DD-YYYY HH24:MI:SS') as pretty_submission_date,
	et.due_date,
	ea.last_modified as submission_date
	from evaluation_answersi ea, 
	     evaluation_tasks et
	where ea.task_id = et.task_id
      and et.task_id = :task_id
      and ea.data is not null
	  and content_revision__is_live(ea.answer_id) = true
    $processed_clause
	
      </querytext>
</fullquery>

</queryset>
