<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="grade_task">      
      <querytext>

	    select et.task_id, 
		et.task_name,
		et.weight
   	    from evaluation_tasksi et, evaluation_grades eg
		where content_revision__is_live(et.task_id) = true
   		  and eg.grade_id = :grade_id
	          and eg.grade_item_id = et.grade_item_id
	    order by task_name

      </querytext>
</fullquery>

<fullquery name="get_grades">      
      <querytext>

		select cu.first_names||', '||cu.last_name as student_name,
		cu.user_id
		$sql_query
   	 	from cc_users cu 
		$orderby

      </querytext>
</fullquery>

<fullquery name="community_get_grades">      
      <querytext>

		select cu.first_names||', '||cu.last_name as student_name,
		cu.user_id
		$sql_query
   	 	from cc_users cu,
		registered_users ru,
	        dotlrn_member_rels_approved app
	    where app.community_id = :community_id
	      and app.user_id = ru.user_id
	      and app.user_id = cu.person_id
	      and app.role = 'student'		
		$orderby

      </querytext>
</fullquery>

<partialquery name="task_grade">
	  <querytext>         

	, [lc_numeric trunc(evaluation__task_grade(cu.user_id,$task_id),2)] as task_$task_id 

	  </querytext>
</partialquery>

<partialquery name="grade_total_grade">
	  <querytext>         

	, [lc_numeric trunc(evaluation__grade_total_grade(cu.user_id,:grade_id),2)] as total_grade 

	  </querytext>
</partialquery>


</queryset>
