<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_party_name">      
      <querytext>

		select evaluation__party_name(:party_id,:task_id)

      </querytext>
</fullquery>

<fullquery name="check_evaluated">      
      <querytext>

		select grade from evaluation_student_evals where party_id = :party_id and task_id = :task_id and content_revision__is_live(evaluation_id) = true

      </querytext>
</fullquery>

<fullquery name="verify_grade_change">      
      <querytext>

		select 1 from evaluation_student_evalsi where task_id = :task_id and party_id = :party_id and grade = :grade and description = :comments and content_revision__is_live(evaluation_id) = true
      </querytext>
</fullquery>

<fullquery name="verify_grade_change_wcomments">      
      <querytext>

		select 1 from evaluation_student_evalsi where task_id = :task_id and party_id = :party_id and grade = :grade and description is null and content_revision__is_live(evaluation_id) = true

      </querytext>
</fullquery>

<fullquery name="editing_p">      
      <querytext>

		select evaluation_id from evaluation_student_evals where task_id = :task_id and party_id = :party_id and content_revision__is_live(evaluation_id) = true

      </querytext>
</fullquery>

</queryset>
