<?xml version="1.0"?>

<queryset>
<fullquery name="get_no_of_members">      
      <querytext>

		select count(map.object_id_two) as number_of_members
		from acs_rels map
		where map.object_id_one = :evaluation_group_id
	
      </querytext>
</fullquery>

<fullquery name="get_group_members">      
      <querytext>

		select p.last_name||', '||p.first_names as student_name,
		p.person_id as student_id,
   		map.rel_id
		from persons p, acs_rels map
		where p.person_id = map.object_id_two
		and map.object_id_one = :evaluation_group_id
   		$orderby
	
      </querytext>
</fullquery>

</queryset>
