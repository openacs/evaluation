<?xml version="1.0"?>

<queryset>
<fullquery name="get_grade_info">      
      <querytext>

		select grade_plural_name, weight as grade_weight from evaluation_grades where grade_id = :grade_id
	
      </querytext>
</fullquery>

</queryset>
