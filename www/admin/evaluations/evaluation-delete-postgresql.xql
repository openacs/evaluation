<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_evaluation_info">      
      <querytext>

	    select evaluation__party_name(party_id,:task_id) as party_name
    	from evaluation_student_evals
		where evaluation_id = :evaluation_id
	
      </querytext>
</fullquery>

</queryset>
