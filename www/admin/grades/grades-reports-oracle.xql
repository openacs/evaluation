<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<partialquery name="grade_total_grade">
	  <querytext>         

	, round(evaluation.grade_total_grade(cu.user_id,$grade_id),2) as grade_$grade_id 

	  </querytext>
</partialquery>

<partialquery name="class_total_grade">
	  <querytext>         

	, round(evaluation.class_total_grade(cu.user_id,:package_id),2) as total_grade 

	  </querytext>
</partialquery>

</queryset>
