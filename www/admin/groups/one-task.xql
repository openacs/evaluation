<?xml version="1.0"?>

<queryset>
<fullquery name="get_number_of_members">      
      <querytext>

		select task_name, number_of_members from evaluation_tasks where task_id = :task_id
	
      </querytext>
</fullquery>

<fullquery name="get_info">      
      <querytext>

		select task_name, number_of_members as n_of_members, task_item_id from evaluation_tasks where task_id = :task_id
	
      </querytext>
</fullquery>

<fullquery name="get_students_without_group">      
      <querytext>

		select p.last_name ||', '|| p.first_names as student_name,
		p.person_id as student_id
		from cc_users p
		where p.person_id not in (select map.object_id_two from acs_rels map, evaluation_task_groups etg, evaluation_tasks et
							  where map.object_id_two = p.person_id
							  and map.object_id_one = etg.group_id
							  and etg.task_item_id = :task_item_id
							  and etg.task_item_id = et.task_item_id
							  and et.task_id = :task_id
							  and map.rel_type = 'evaluation_task_group_rel')
		$orderby
	
      </querytext>
</fullquery>

<fullquery name="community_get_students_without_group">      
      <querytext>

		select p.last_name ||', '|| p.first_names as student_name,
		p.person_id as student_id
		from persons p,
                dotlrn_member_rels_approved app
		where p.person_id not in (select map.object_id_two from acs_rels map, evaluation_task_groups etg, evaluation_tasks et
							  where map.object_id_two = p.person_id
							  and map.object_id_one = etg.group_id
							  and etg.task_item_id = :task_item_id
							  and etg.task_item_id = et.task_item_id
							  and et.task_id = :task_id
							  and map.rel_type = 'evaluation_task_group_rel')
	        and app.community_id = :community_id
	        and app.user_id = p.person_id
	        and app.role = 'student'		
		$orderby
	
      </querytext>
</fullquery>

<fullquery name="get_task_groups">      
      <querytext>

		select g.group_id as evaluation_group_id, g.group_name,
		count(map.object_id_two) as number_of_members
		from groups g, evaluation_task_groups etg, evaluation_tasks et,
		acs_rels map
		where g.group_id = etg.group_id
		  and etg.group_id = map.object_id_one
		  and map.rel_type = 'evaluation_task_group_rel'
		  and etg.task_item_id = :task_item_id
	   	  and et.task_id = :task_id
		group by g.group_id, g.group_name
   		$orderby_groups
	
      </querytext>
</fullquery>

<fullquery name="get_group_members">      
      <querytext>

		select p.last_name||', '||p.first_names from persons p, acs_rels map
                                            where p.person_id = map.object_id_two
                                              and map.object_id_one = :evaluation_group_id
	
      </querytext>
</fullquery>

<fullquery name="get_groups_for_task">      
      <querytext>

	select count(*)
	from evaluation_task_groups etg, evaluation_tasks et, acs_rels map
	where etg.task_item_id = et.task_item_id
          and map.rel_type = 'evaluation_task_group_rel'
          and map.object_id_one = etg.group_id
	  and et.task_id = :task_id
	
      </querytext>
</fullquery>

</queryset>
