<?xml version="1.0"?>

<queryset>

<fullquery name="package_grades">      
      <querytext>

		select count(eg.grade_id) 
          from evaluation_grades eg, acs_objects ao, cr_items cri 
          where cri.live_revision = eg.grade_id
          and eg.grade_item_id = ao.object_id
   		  and ao.context_id = [ad_conn package_id]

      </querytext>
</fullquery>

<fullquery name="grade_type">      
      <querytext>

	    select eg.grade_id, 
		eg.grade_plural_name,
		round(eg.weight,0) as weight
   	    from evaluation_grades eg, acs_objects ao, cr_items cri
		where cri.live_revision = eg.grade_id
          and eg.grade_item_id = ao.object_id
   		  and ao.context_id = :package_id
	    order by grade_plural_name

      </querytext>
</fullquery>

<fullquery name="grades_report">      
      <querytext>

	select cu.first_names||', '||cu.last_name as student_name,
	cu.user_id
	$sql_query
    from cc_users cu
    $orderby

      </querytext>
</fullquery>

<fullquery name="community_grades_report">      
      <querytext>

	select cu.first_names||', '||cu.last_name as student_name,
	cu.user_id
	$sql_query
    from cc_users cu,
        dotlrn_member_rels_approved app
    where app.community_id = :community_id
      and app.user_id = cu.person_id
      and app.role in ('student','member')
    $orderby

      </querytext>
</fullquery>

</queryset>
