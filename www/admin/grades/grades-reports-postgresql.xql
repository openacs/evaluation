<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="package_grades">      
      <querytext>

		select count(eg.grade_id) 
          from evaluation_gradesx eg, acs_objects ao 
          where content_revision__is_live(eg.grade_id) = true
          and eg.item_id = ao.object_id
   		  and ao.context_id = [ad_conn package_id]

      </querytext>
</fullquery>

<fullquery name="grade_type">      
      <querytext>

	    select eg.grade_id, 
		eg.grade_name,
		eg.weight
   	    from evaluation_gradesx eg, acs_objects ao
		where content_revision__is_live(eg.grade_id) = true
          and eg.item_id = ao.object_id
   		  and ao.context_id = :package_id
	    order by grade_name

      </querytext>
</fullquery>

<partialquery name="grade_total_grade">
	  <querytext>         

	, trunc(evaluation__grade_total_grade(cu.user_id,$grade_id),2) as grade_$grade_id 

	  </querytext>
</partialquery>

<partialquery name="class_total_grade">
	  <querytext>         

	, trunc(evaluation__class_total_grade(cu.user_id,$package_id),2) as total_grade 

	  </querytext>
</partialquery>

<fullquery name="grades_report">      
      <querytext>

	select cu.first_names||', '||cu.last_name as student_name
	$sql_query
    from cc_users cu
    $orderby

      </querytext>
</fullquery>

</queryset>
