<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_grades">      
      <querytext>

		select eg.grade_plural_name,
		eg.grade_id
   	 	from evaluation_gradesx eg, acs_objects ao, cr_items cri
		where cri.live_revision = eg.grade_id
          and eg.item_id = ao.object_id
   		  and ao.context_id = :package_id
		order by grade_plural_name desc
	
      </querytext>
</fullquery>


<fullquery name="student_info">      
      <querytext>

	select person__name(:student_id) as student_name,
                      p.email
                      from parties p
                      where p.party_id = :student_id

      </querytext>
</fullquery>

<fullquery name="max_possible_grade">      
      <querytext>

    select sum(et.weight*eg.weight/100)
    from evaluation_tasks et,
    evaluation_grades eg,
    cr_items cri1,
    cr_items cri2,
    acs_objects ao
    where et.grade_item_id = eg.grade_item_id
    and cri1.live_revision = eg.grade_id
    and cri2.live_revision = et.task_id
    and et.requires_grade_p = 't'
    and ao.object_id = eg.grade_item_id
    and ao.context_id = :package_id

      </querytext>
</fullquery>

<fullquery name="get_total_grade">      
      <querytext>

        select coalesce(sum((ese.grade*et.weight*eg.weight)/10000),0) as grade
        from evaluation_grades eg, evaluation_tasks et, evaluation_student_evals ese, acs_objects ao
        where et.task_item_id = ese.task_item_id
		  and et.grade_item_id = eg.grade_item_id
          and eg.grade_item_id = ao.object_id
   		  and ao.context_id = :package_id
   		  and ese.party_id = 
	( select
	CASE 
	  WHEN et3.number_of_members = 1 THEN :student_id
	  ELSE 
	(select etg2.group_id from evaluation_task_groups etg2,
                                                      evaluation_tasks et2,
                                                      acs_rels map
                                                      where map.object_id_one = etg2.group_id
                                                        and map.object_id_two = :student_id
                                                        and etg2.task_item_id = et2.task_item_id
                                                        and et2.task_id = et.task_id)
	END as nom
               from evaluation_tasks et3
              where et3.task_id = et.task_id
	)
	and et.requires_grade_p = 't'
	and exists (select 1 from cr_items where live_revision = eg.grade_id)
	and exists (select 1 from cr_items where live_revision = et.task_id)
	and exists (select 1 from cr_items where live_revision = ese.evaluation_id)

--	select evaluation__class_total_grade(:student_id,:package_id)

      </querytext>
</fullquery>

</queryset>
