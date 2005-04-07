<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="evaluated_students">      
      <querytext>

	select ev.party_id,
	case when et.number_of_members = 1 then 
	(select last_name||', '||first_names from persons where person_id = ev.party_id)
	else  
 	(select group_name from groups where group_id = ev.party_id)
	end as party_name,
	round(ev.grade,2) as grade,
	ev.last_modified as evaluation_date,
	et.online_p,
	et.due_date,
	ev.evaluation_id
	from evaluation_tasks et,
	     evaluation_student_evalsi ev,
	     $roles_table	
	     cr_items cri
	where et.task_id = :task_id
	  and et.task_item_id = ev.task_item_id
	  $roles_clause
	  and cri.live_revision = ev.evaluation_id
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
	    from evaluation_answersi ea, cr_items cri
            where ea.party_id = :party_id 
	    and ea.task_item_id = :task_item_id
	    and cri.live_revision = ea.answer_id
	
      </querytext>
</fullquery>

<fullquery name="get_not_evaluated_wa_students">      
      <querytext>

	select ev.party_id,
	case when et.number_of_members = 1 then 
	(select last_name||', '||first_names from persons where person_id = ev.party_id)
	else  
 	(select group_name from groups where group_id = ev.party_id)
	end as party_name,
        ev.party_id,
	ev.data as answer_data,
	ev.title as answer_title,
	ev.revision_id,
	to_char(ev.last_modified, 'YYYY-MM-DD HH24:MI:SS') as submission_date_ansi,
	et.due_date,
	ev.last_modified as submission_date
	from evaluation_answersi ev, 
	     evaluation_tasks et,
	     $roles_table	
	     cr_items cri
	where ev.task_item_id = et.task_item_id
          and et.task_id = :task_id
          and ev.data is not null
	  $roles_clause
          and cri.live_revision = ev.answer_id
        $processed_clause
	$orderby_wa

      </querytext>
</fullquery>

</queryset>
