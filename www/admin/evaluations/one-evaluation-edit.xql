<?xml version="1.0"?>

<queryset>

<fullquery name="get_evaluation_info">      
      <querytext>

		select ese.party_id,
		ese.item_id,
		ese.task_item_id
		from evaluation_student_evalsx ese
		where ese.evaluation_id = :evaluation_id
	
      </querytext>
</fullquery>

</queryset>
