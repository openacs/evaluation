<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_evaluation_groups">      
      <querytext>

	select g.group_name, g.group_id as evaluation_group_id,
	count(map.object_id_two) as number_of_members
	from groups g, acs_rels map, evaluation_task_groups etg
	where map.object_id_one = g.group_id
	  and g.group_id = etg.group_id
	  and etg.task_id = :task_id
    group by g.group_id, g.group_name
	$orderby
	
      </querytext>
</fullquery>

</queryset>
