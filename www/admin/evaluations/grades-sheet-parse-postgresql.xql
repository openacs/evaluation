<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_party_name">      
      <querytext>

		select evaluation__party_name(:party_id,:task_id)

      </querytext>
</fullquery>

<fullquery name="check_evaluated">      
      <querytext>

		select ese.grade 
		from evaluation_student_evals ese, evaluation_tasks et
		where ese.party_id = :party_id
		and ese.task_item_id = et.task_item_id
		and et.task_id = :task_id
		and content_revision__is_live(ese.evaluation_id) = true

      </querytext>
</fullquery>

<fullquery name="verify_grade_change">      
      <querytext>

		select 1 
		from evaluation_student_evalsi ese, evaluation_tasks et
		 where ese.task_item_id = et.task_item_id
		and et.task_id = :task_id 
		and ese.party_id = :party_id 
		and ese.grade = :grade 
		and ese.description = :comments 
		and content_revision__is_live(ese.evaluation_id) = true
      </querytext>
</fullquery>

<fullquery name="verify_grade_change_wcomments">      
      <querytext>

		select 1 from evaluation_student_evalsi ese, evaluation_tasks et
		where ese.task_item_id = et.task_item_id 
		and et.task_id = :task_id
		and ese.party_id = :party_id 
		and ese.grade = :grade 
		and ese.description is null 
		and content_revision__is_live(ese.evaluation_id) = true

      </querytext>
</fullquery>

<fullquery name="editing_p">      
      <querytext>

		select ese.evaluation_id 
		from evaluation_student_evals ese, evaluation_tasks et
		where ese.task_item_id = et.task_item_id 
		and et.task_id = :task_id
		and ese.party_id = :party_id 
		and content_revision__is_live(ese.evaluation_id) = true

      </querytext>
</fullquery>

</queryset>
