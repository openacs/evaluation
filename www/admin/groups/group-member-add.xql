<?xml version="1.0"?>

<queryset>

<fullquery name="get_evaluation_groups">      
      <querytext>

	select g.group_name, 
	g.group_id as evaluation_group_id,
	count(map.object_id_two) as number_of_members
	from groups g, acs_rels map, evaluation_task_groups etg, evaluation_tasks et
	where map.object_id_one = g.group_id
	  and g.group_id = etg.group_id
	  and etg.task_item_id = et.task_item_id
	  and et.task_id = :task_id
    group by g.group_id, g.group_name
	$orderby
	
      </querytext>
</fullquery>

</queryset>
