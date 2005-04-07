<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<partialquery name="grade_total_grade">
	  <querytext>         

	, round((select coalesce((select sum((ese.grade*et.weight*eg.weight)/10000) 
        from   evaluation_grades eg, evaluation_tasks et, evaluation_student_evals ese
        where et.task_item_id = ese.task_item_id 
		  and et.grade_item_id = eg.grade_item_id 
          and eg.grade_id = $grade_id 
   		  and ese.party_id =  
	( select 
	CASE  
	  WHEN et3.number_of_members = 1 THEN cu.user_id 
	  ELSE  
	(select etg2.group_id from evaluation_task_groups etg2, 
                                                      evaluation_tasks et2, 
                                                      acs_rels map 
                                                      where map.object_id_one = etg2.group_id 
                                                        and map.object_id_two = cu.user_id 
                                                        and etg2.task_item_id = et2.task_item_id 
                                                        and et2.task_id = et.task_id) 
	END as nom 
               from evaluation_tasks et3 
              where et3.task_id = et.task_id 
	) 
	and et.requires_grade_p = 't'
	and exists (select 1 from cr_items where live_revision = et.task_id) 
	and exists (select 1 from cr_items where live_revision = ese.evaluation_id)),0)),2) as grade_${grade_id}
 
--	, [lc_numeric trunc(evaluation__grade_total_grade(cu.user_id,$grade_id),2)] as grade_$grade_id 

	  </querytext>
</partialquery>

<partialquery name="class_total_grade">
	  <querytext>         

	, round(coalesce((select sum(ese.grade*et.weight*eg.weight/10000)
        from evaluation_grades eg, evaluation_tasks et, evaluation_student_evals ese, acs_objects ao,
	cr_items cri1, cr_items cri2, cr_items cri3 
        where et.task_item_id = ese.task_item_id 
		  and et.grade_item_id = eg.grade_item_id 
          and eg.grade_item_id = ao.object_id 
   		  and ao.context_id = $package_id 
   		  and ese.party_id = 
	( select 
	CASE  
	  WHEN et3.number_of_members = 1 THEN cu.user_id 
	  ELSE 
	(select etg2.group_id from evaluation_task_groups etg2, 
                                                     evaluation_tasks et2, 
                                                      acs_rels map 
                                                      where map.object_id_one = etg2.group_id 
                                                        and map.object_id_two = cu.user_id 
                                                        and etg2.task_item_id = et2.task_item_id 
                                                        and et2.task_id = et.task_id) 
	END as nom 
               from evaluation_tasks et3 
              where et3.task_id = et.task_id 
	) 
	and cri1.live_revision = eg.grade_id
	and cri2.live_revision = et.task_id
	and cri3.live_revision = ese.evaluation_id),0),2) as total_grade
--	, [lc_numeric trunc(evaluation__class_total_grade(cu.user_id,$package_id),2)] as total_grade 

	  </querytext>
</partialquery>

</queryset>
