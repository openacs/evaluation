<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_evaluated_students">      
      <querytext>

	select evaluation__party_name(ese.party_id,et.task_id) as party_name,
	ese.party_id,
	ese.grade,
	ese.last_modified as evaluation_date,
	et.online_p,
	et.due_date,
	et.task_item_id,
	ese.show_student_p,
	ese.evaluation_id,
	ese.item_id
	from evaluation_tasks et,
	     evaluation_student_evalsi ese 
	where et.task_id = :task_id
	  and et.task_item_id = ese.task_item_id
	  and content_revision__is_live(ese.evaluation_id) = true
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
	    and content_revision__is_live(ea.answer_id) = true
	
      </querytext>
</fullquery>

<fullquery name="compare_evaluation_date">      
      <querytext>

	select 1 from dual where :submission_date  > :evaluation_date
	
      </querytext>
</fullquery>

<fullquery name="compare_submission_date">      
      <querytext>

	select 1 from dual where :submission_date > :due_date
	
      </querytext>
</fullquery>

</queryset>
