<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_task_info">      
      <querytext>

	select et.task_name,
		eg.grade_id,
		eg.grade_name,
		eg.weight as grade_weight,
		et.weight as task_weight,
		to_char(et.due_date,'Month DD YYYY') as due_date,
		et.number_of_members,
		et.online_p
		from evaluation_grades eg, evaluation_tasks et
		where et.task_id = :task_id
		  and et.grade_id = eg.grade_id
	
      </querytext>
</fullquery>

<fullquery name="count_evaluated_students">      
      <querytext>

		select count(*) from evaluation_student_evals where task_id = :task_id
	
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

		select count(*) from evaluation_task_groups etg where etg.task_id = :task_id 
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

		select count(*) from cc_users p 
		$not_in_clause
	
      </querytext>
</fullquery>

<partialquery name="sql_query_one">
	  <querytext>         
		select acs_group__name(etg.group_id) as party_name,
		etg.group_id as party_id
		from evaluation_task_groups etg
        where etg.task_id = :task_id
		$not_in_clause
		$orderby_na
	  </querytext>
</partialquery>

<partialquery name="sql_query_two">
	  <querytext>         
		select p.person_id as party_id,
		p.last_name||', '||p.first_names as party_name
		from cc_users p 
		$not_in_clause
		$orderby_na
	  </querytext>
</partialquery>

<fullquery name="get_not_evaluated_na_students">      
      <querytext>

		$sql_query
	
      </querytext>
</fullquery>

</queryset>
