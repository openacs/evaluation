<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="grade_task">      
      <querytext>

	    select et.task_id, 
		et.task_name,
		et.weight
   	    from evaluation_tasksi et
		where content_revision__is_live(et.task_id) = true
   		  and et.grade_id = :grade_id
	    order by task_name

      </querytext>
</fullquery>

<fullquery name="get_grades">      
      <querytext>

		select cu.first_names||', '||cu.last_name as student_name
		$sql_query
   	 	from cc_users cu 
   		order by student_name asc

      </querytext>
</fullquery>

<partialquery name="task_grade">
	  <querytext>         

	, trunc(evaluation__task_grade(cu.user_id,$task_id),2) as task_$task_id 

	  </querytext>
</partialquery>

<partialquery name="grade_total_grade">
	  <querytext>         

	, trunc(evaluation__grade_total_grade(cu.user_id,:grade_id),2) as total_grade 

	  </querytext>
</partialquery>


</queryset>
