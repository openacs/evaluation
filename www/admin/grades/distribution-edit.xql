<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="grade_info">      
      <querytext>

	select eg.grade_name,
		eg.weight as grade_weight,
		eg.comments as grade_comments
		from evaluation_gradesi eg
		where grade_id = :grade_id
	
      </querytext>
</fullquery>

</queryset>
