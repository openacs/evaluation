<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_grade_info">      
      <querytext>

		select grade_plural_name, weight as grade_weight from evaluation_grades where grade_id = :grade_id
	
      </querytext>
</fullquery>

</queryset>
