<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_grades">      
      <querytext>

		select eg.grade_plural_name,
		eg.grade_id
   	 	from evaluation_gradesx eg, acs_objects ao
		where content_revision__is_live(eg.grade_id) = true
          and eg.item_id = ao.object_id
   		  and ao.context_id = :package_id
		order by grade_plural_name desc

	
      </querytext>
</fullquery>

<fullquery name="total_grade">      
      <querytext>

		select evaluation__class_total_grade(:user_id,:package_id)
	
      </querytext>
</fullquery>

<fullquery name="max_grade">      
      <querytext>

	select sum(et.weight*eg.weight)/100 
	from evaluation_gradesi eg, evaluation_tasks et, acs_objects ao
	where eg.grade_id = et.grade_id
	  and eg.item_id = ao.object_id
	  and ao.context_id = :package_id
	  and content_revision__is_live(eg.grade_id) = true
	  and content_revision__is_live(et.task_id) = true
	
      </querytext>
</fullquery>

</queryset>