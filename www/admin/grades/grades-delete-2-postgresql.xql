<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="delete_grade">      
      <querytext>

		select evaluation__delete_grade (
									  :grade_id
								  );
	
      </querytext>
</fullquery>

</queryset>
