<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_evaluated_students">      
      <querytext>

	select evaluation__party_name(ese.party_id,et.task_id) as party_name,
	ea.data as answer_data,
	ea.title as answer_title,
	ese.party_id,
	ese.grade,
	ese.item_id,
	ese.show_student_p,
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
	  and ese.grade is not null
	
      </querytext>
</fullquery>

</queryset>
