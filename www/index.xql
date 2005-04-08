<?xml version="1.0"?>

<queryset>

<fullquery name="get_grades">      
      <querytext>

		select eg.grade_plural_name,
		eg.grade_id,
	 	eg.grade_item_id
   	 	from evaluation_grades eg, acs_objects ao, cr_items cri
		where cri.live_revision = eg.grade_id
          and eg.grade_item_id = ao.object_id
   		  and ao.context_id = :package_id
		order by grade_plural_name desc
	
      </querytext>
</fullquery>

<fullquery name="max_possible_grade">      
      <querytext>

    select sum(round(et.weight*eg.weight/100,2))
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

</queryset>

