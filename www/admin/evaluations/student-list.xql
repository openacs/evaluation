<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

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

<fullquery name="get_not_evaluated_na">      
      <querytext>

 		select count(*) from evaluation_task_groups where group_id not in ([join $done_students ","])
	
      </querytext>
</fullquery>

<partialquery name="not_in_clause">
	  <querytext>         
		and etg.group_id not in  ([join $done_students ","])
	  </querytext>
</partialquery>

<fullquery name="count_not_eval_na">      
      <querytext>

		select count(*) from evaluation_task_groups etg, evaluation_tasks et
		 where etg.task_item_id = et.task_item_id
		and et.task_id = :task_id 
		$not_in_clause
	
      </querytext>
</fullquery>

<partialquery name="not_yet_in_clause">
	  <querytext>         
		where p.person_id not in ([join $done_students ","])
	  </querytext>
</partialquery>

<fullquery name="get_not_evaluated_left">      
      <querytext>

		select count(*) from persons p 
		$not_in_clause
	
      </querytext>
</fullquery>

<fullquery name="get_community_not_evaluated_left">      
      <querytext>

		select count(*) 
		from persons p,
		registered_users ru,
                dotlrn_member_rels_approved app
		$not_in_clause
	        and app.community_id = :community_id
                and app.user_id = ru.user_id
	        and app.user_id = p.person_id
	        and app.role = 'student'
	
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

<partialquery name="sql_query_individual">
	  <querytext>         
		select p.person_id as party_id,
		p.last_name||', '||p.first_names as party_name
		from persons p 
		$not_in_clause
		$orderby_na
	  </querytext>
</partialquery>

<partialquery name="sql_query_community_individual">
	  <querytext>         
            select app.user_id as party_id,
  		   p.last_name||', '||p.first_names as party_name
            from registered_users ru,
                 dotlrn_member_rels_approved app,
		 persons p
            $not_in_clause
	      and app.community_id = :community_id
              and app.user_id = ru.user_id
	      and app.user_id = p.person_id
	      and app.role = 'student'
	      $orderby_na
	  </querytext>
</partialquery>

<fullquery name="get_not_evaluated_na_students">      
      <querytext>

		$sql_query
	
      </querytext>
</fullquery>

</queryset>
