<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_evaluation_info">      
      <querytext>

		select ese.party_id,
		ese.item_id
		from evaluation_student_evalsx ese
		where ese.evaluation_id = :evaluation_id
	
      </querytext>
</fullquery>

</queryset>
