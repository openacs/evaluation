<?xml version="1.0"?>

<queryset>

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
                dotlrn_member_rels_approved app
		$not_in_clause
	        and app.community_id = :community_id
	        and app.user_id = p.person_id
	        and app.role = 'student'
	
      </querytext>
</fullquery>

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
	      and app.role = 'student'

	  </querytext>
</partialquery>

<fullquery name="get_not_evaluated_na_students">      
      <querytext>

		$sql_query
		$orderby_na
	
      </querytext>
</fullquery>

</queryset>
