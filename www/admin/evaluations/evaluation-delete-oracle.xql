<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_evaluation_info">      
      <querytext>

	    select evaluation.party_name(party_id,:task_id) as party_name
    	from evaluation_student_evals
		where evaluation_id = :evaluation_id
	
      </querytext>
</fullquery>

</queryset>
