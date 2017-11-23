<?xml version="1.0"?>

<queryset>

<fullquery name="get_class_grades">      
      <querytext>

	    select eg.grade_id, 
		eg.item_id,
		eg.grade_plural_name,
		eg.comments,
		eg.weight,
		cri.live_revision
   	    from evaluation_gradesx eg, acs_objects ao, cr_items cri
          where eg.item_id = ao.object_id
	        and eg.grade_item_id = cri.item_id
		and (cri.live_revision = eg.grade_id or cri.latest_revision = eg.grade_id)
   		  and ao.context_id = :package_id
		$orderby

      </querytext>
</fullquery>

</queryset>
