<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="evaluation_relationship_new">      
      <querytext>

		select acs_rel__new (
							 null,
							 'evaluation_task_group_rel',
							 :evaluation_group_id,
							 $student_ids($student_id),
							 :package_id,
							 :creation_user_id,
							 :creation_ip
							 );

      </querytext>
</fullquery>

<fullquery name="task_info">      
      <querytext>
	
		select task_item_id
		from evaluation_tasks
		where task_id = :task_id
	
      </querytext>
</fullquery>

</queryset>
