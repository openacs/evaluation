<?xml version="1.0"?>

<queryset>

<fullquery name="grade_info">      
      <querytext>

    select eg.weight as grade_weight,
    eg.grade_plural_name
    from evaluation_grades eg
    where eg.grade_id = :grade_id

      </querytext>
</fullquery>

<fullquery name="grade_names">      
      <querytext>

		select grade_name, grade_plural_name from evaluation_grades where grade_id = :grade_id
	
      </querytext>
</fullquery>

</queryset>
