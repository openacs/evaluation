<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="evaluation_info">      
      <querytext>

		select evaluation__party_name(ese.party_id,:task_id) as party_name,
		ese.grade,
		ese.show_student_p,
		ese.description as comments
		from evaluation_student_evalsx ese
		where ese.evaluation_id = :evaluation_id
	
      </querytext>
</fullquery>

</queryset>
