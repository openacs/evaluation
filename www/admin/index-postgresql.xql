<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

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

</queryset>
