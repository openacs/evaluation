<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_evaluated_students">      
      <querytext>

	select evaluation.party_name(ese.party_id,et.task_id) as party_name,
	ese.party_id,
	round(ese.grade,2) as grade,
	to_char(ese.last_modified,'YYYY-MM-DD HH24:MI:SS') as evaluation_date_ansi,
	ese.last_modified as evaluation_date,
	et.online_p,
	to_char(et.due_date,'YYYY-MM-DD HH24:MI:SS') as due_date_ansi,
	et.due_date,
	et.task_item_id,
	ese.show_student_p,
	ese.evaluation_id,
	ese.item_id
	from evaluation_tasks et,
	     evaluation_student_evalsi ese 
	where et.task_id = :task_id
	  and et.task_item_id = ese.task_item_id
	  and content_revision.is_live(ese.evaluation_id) = 't'
        $orderby       
	
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
	    and content_revision.is_live(ea.answer_id) = 't'
	
      </querytext>
</fullquery>

</queryset>
