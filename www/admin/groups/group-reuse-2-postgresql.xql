<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="evaluation_group">      
      <querytext>

		select etg.group_id as from_evaluation_group_id,
		g.group_name
		from evaluation_task_groups etg, groups g
		where etg.task_id = :from_task_id
          and etg.group_id = g.group_id
	
      </querytext>
</fullquery>

<fullquery name="evaluation_relationship_new">      
      <querytext>

				select acs_rel__new (
									 null,
									 'evaluation_task_group_rel',
									 :new_evaluation_group_id,
									 map.object_id_two,
									 :package_id,
									 :creation_user_id,
									 :creation_ip
									 )
               from acs_rels map where map.object_id_one = :from_evaluation_group_id;
	
      </querytext>
</fullquery>

</queryset>
