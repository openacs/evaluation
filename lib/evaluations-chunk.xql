<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_grade_info">      
      <querytext>

		select upper(grade_plural_name) as grade_plural_name, grade_plural_name as low_name,grade_name,weight as grade_weight,weight as category_weight from evaluation_grades where grade_id = :grade_id
	
      </querytext>
</fullquery>

</queryset>
