<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_total_weight">      
      <querytext>

	select nvl(sum(eg.weight),0) as total_weight
	from evaluation_gradesi eg, acs_objects ao
	where content_revision.is_live(eg.grade_id) = 't'
	  and ao.context_id = :package_id
 	  and eg.item_id = ao.object_id

      </querytext>
</fullquery>

<fullquery name="sum_grades">      
      <querytext>
    select nvl(sum(eg.weight),0)
    from evaluation_gradesx eg, acs_objects ao 
    where content_revision.is_live(eg.grade_id) = 't'
    and eg.item_id = ao.object_id 
    and ao.context_id = :package_id
      </querytext>
</fullquery>

</queryset>
