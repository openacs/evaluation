<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_parties">      
      <querytext>

	select evaluation__party_name(ese.party_id,ese.task_id) as party_name,
	ese.party_id
	from evaluation_student_evals ese
	where content_revision__is_live(ese.evaluation_id) = true
	 and ese.task_id = :task_id

      </querytext>
</fullquery>

</queryset>
