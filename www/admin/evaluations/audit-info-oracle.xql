<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_parties">      
      <querytext>

	select evaluation.party_name(ese.party_id,:task_id) as party_name,
	ese.party_id
	from evaluation_student_evals ese
	where content_revision.is_live(ese.evaluation_id) = 't'
	 and ese.task_item_id = :task_item_id

      </querytext>
</fullquery>

</queryset>
