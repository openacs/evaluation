<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_class_grades">      
      <querytext>

	    select eg.grade_id, 
		eg.item_id,
		eg.grade_name,
		eg.comments,
		eg.weight
   	    from evaluation_gradesx eg, acs_objects ao
		where content_revision__is_live(eg.grade_id) = true
          and eg.item_id = ao.object_id
   		  and ao.context_id = :package_id
		$orderby

      </querytext>
</fullquery>

<fullquery name="get_total_weight">      
      <querytext>

		select coalesce(sum(weight),0) as total_weight
		from evaluation_gradesi
		where content_revision__is_live(grade_id) = true
		  and context_id = :package_id

      </querytext>
</fullquery>

<fullquery name="sum_grades">      
      <querytext>
    select sum(eg.weight) 
    from evaluation_gradesx eg, acs_objects ao 
    where content_revision__is_live(eg.grade_id) = true 
    and eg.item_id = ao.object_id 
    and ao.context_id = :package_id
      </querytext>
</fullquery>

</queryset>
