<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="evaluation_relationship_new">      
      <querytext>
       begin
		:1 := acs_rel.new (
						rel_id => null,
						rel_type => 'evaluation_task_group_rel',
						object_id_one => :evaluation_group_id,
						object_id_two => $student_ids($student_id),
						context_id => :package_id,
						creation_user => :creation_user_id,
						creation_ip => :creation_ip
							 );
      end;
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
