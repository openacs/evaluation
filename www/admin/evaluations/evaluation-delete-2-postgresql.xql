<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="delete_evaluation">      
      <querytext>

			select evaluation__delete_student_eval (
											 :evaluation_id
											 );
	
      </querytext>
</fullquery>

</queryset>
