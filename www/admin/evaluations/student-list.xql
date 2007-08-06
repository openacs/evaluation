<?xml version="1.0"?>

<queryset>

<partialquery name="not_in_clause">
	  <querytext>         
		and etg.group_id not in  ([join $done_students ","])
	  </querytext>
</partialquery>

<partialquery name="roles_table_query">
	  <querytext>         

      dotlrn_member_rels_approved app,

	  </querytext>
</partialquery>

<partialquery name="roles_clause_query">
	  <querytext>         

      and app.community_id = :community_id
      and app.user_id = ev.party_id
      and app.role in ('student','member')

	  </querytext>
</partialquery>

<partialquery name="not_yet_in_clause_non_empty">
	  <querytext>         
		where p.person_id not in ([join $done_students ","])
	  </querytext>
</partialquery>

<partialquery name="not_yet_in_clause_empty">
	  <querytext>         
 
      , cc_users cu 
      where p.person_id = cu.person_id 
      and cu.member_state = 'approved'
      
          </querytext>
</partialquery>

<partialquery name="sql_query_individual">
	  <querytext>         

		select p.person_id as party_id,
		p.last_name||', '||p.first_names as party_name
		from persons p 
		$not_in_clause

	  </querytext>
</partialquery>

<partialquery name="sql_query_community_individual">
	  <querytext>         

            select app.user_id as party_id,
  		   p.last_name||', '||p.first_names as party_name
            from dotlrn_member_rels_approved app,
		 persons p
            $not_in_clause
	      and app.community_id = :community_id
	      and app.user_id = p.person_id
	      and app.role in ('student','member')

	  </querytext>
</partialquery>

<fullquery name="get_not_evaluated_na_students">      
      <querytext>

		$sql_query
		$orderby_na
	
      </querytext>
</fullquery>

<fullquery name="compare_evaluation_date">      
      <querytext>

	select 1 from dual where :submission_date_ansi > :evaluation_date_ansi
	
      </querytext>
</fullquery>

<fullquery name="compare_submission_date">      
      <querytext>

	select 1 from dual where :submission_date_ansi > :due_date_ansi
	
      </querytext>
</fullquery>

<partialquery name="processed_clause">
	  <querytext>         

		and ev.party_id not in ([join $done_students ","]) 

	  </querytext>
</partialquery>

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


<partialquery name="sql_query_groups">
	  <querytext>         

		select g.group_id as party_id,
		g.group_name as party_name
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

</queryset>
