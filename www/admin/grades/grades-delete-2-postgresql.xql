<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="delete_grade">      
      <querytext>

		select evaluation__delete_grade(grade_item_id) from evaluation_grades where grade_id = :grade_id;
	
      </querytext>
</fullquery>

</queryset>
