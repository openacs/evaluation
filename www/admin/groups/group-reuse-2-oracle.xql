<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="evaluation_relationship_new">      
      <querytext>

		begin
			:1 := acs_rel.new (
									 null,
									 'evaluation_task_group_rel',
									 :new_evaluation_group_id,
									 :new_member_id,
									 :package_id,
									 :creation_user_id,
									 :creation_ip
									 );
		end;

      </querytext>
</fullquery>

</queryset>
