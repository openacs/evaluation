<?xml version="1.0"?>

<queryset>


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

<fullquery name="evaluation_group">      
      <querytext>

		select etg.group_id as from_evaluation_group_id,
		g.group_name
		from evaluation_task_groups etg, groups g, evaluation_tasks et
		where etg.task_item_id = et.task_item_id 
		  and et.task_id = :from_task_id
          	  and etg.group_id = g.group_id
	
      </querytext>
</fullquery>

<fullquery name="task_info">      
      <querytext>
	
		select task_item_id
		from evaluation_tasks
		where task_id = :task_id
	
      </querytext>
</fullquery>

<fullquery name="from_rel">      
      <querytext>

	    select map.object_id_two as new_member_id
	    from acs_rels map 
	    where map.object_id_one = :from_evaluation_group_id

      </querytext>
</fullquery>

</queryset>
