<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="grades_wa_new">      
      <querytext>

	select count(*) 
	from evaluation_student_evals ese, evaluation_tasks est 
	where ese.party_id = :party_id 
	and ese.task_item_id = :task_item_id 
	and content_revision__is_live(ese.evaluation_id) = true 
	and est.task_id = :task_id and est.task_item_id = ese.task_item_id

      </querytext>
</fullquery>

<fullquery name="grades_na_new">      
      <querytext>

	select count(*) 
	from evaluation_student_evals ese, evaluation_tasks est 
	where ese.party_id = :party_id 
	and ese.task_item_id = :task_item_id 
	and content_revision__is_live(ese.evaluation_id) = true 
	and ese.task_item_id = est.task_item_id and est.task_id = :task_id

      </querytext>
</fullquery>

<fullquery name="">      
      <querytext>

      </querytext>
</fullquery>

</queryset>
