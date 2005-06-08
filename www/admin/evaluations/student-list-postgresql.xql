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
	ev.evaluation_id,
	et.forums_related_p,
	(select description from  evaluation_student_evalsx where evaluation_id=ev.evaluation_id) as comments
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
	    ea.last_modified as submission_date,
	    (select comment from evaluation_answers where answer_id=ea.revision_id) as s_comment
	    from evaluation_answersi ea, cr_items cri
            where ea.party_id = :party_id 
	    and ea.task_item_id = :task_item_id
	    and cri.live_revision = ea.answer_id
	
      </querytext>
</fullquery>

<partialquery name="processed_clause">
	  <querytext>         

		and ev.party_id not in ([join $done_students ","]) 

	  </querytext>
</partialquery>

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
	ev.last_modified as submission_date,
	et.forums_related_p
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
		et.online_p,
		et.points,
		et.perfect_score,
	        et.forums_related_p
		from evaluation_grades eg, evaluation_tasks et, cr_items cri
		where et.task_id = :task_id
		  and et.grade_item_id = eg.grade_item_id
		  and cri.live_revision = eg.grade_id
	
      </querytext>
</fullquery>

<partialquery name="sql_query_groups">
	  <querytext>         

		select g.group_name as party_name,
		g.group_id as party_id
		from groups g, evaluation_task_groups etg, evaluation_tasks et,
		acs_rels map
		where g.group_id = etg.group_id
		  and etg.group_id = map.object_id_one
		  and map.rel_type = 'evaluation_task_group_rel'
		  and etg.task_item_id = et.task_item_id
	   	  and et.task_id = :task_id
		  $not_in_clause
		group by g.group_id, g.group_name

	  </querytext>
</partialquery>

<fullquery name="class_students">      
      <querytext>

      </querytext>
</fullquery>

<fullquery name="class_students">      
      <querytext>
	select ev.party_id,
	case when et.number_of_members = 1 then 
	(select last_name||', '||first_names from persons where person_id = ev.party_id)
	else  
 	(select group_name from groups where group_id = ev.party_id)
	end as party_name
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
	union $sql_query
      </querytext>
</fullquery>

</queryset>