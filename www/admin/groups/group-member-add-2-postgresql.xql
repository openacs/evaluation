<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="associate_student">      
      <querytext>

	select coalesce((select acs_rel__new (
						 null,
						 'evaluation_task_group_rel',
						 :evaluation_group_id,
						 :student_id,
						 :package_id,
						 :creation_user_id,
						 :creation_ip
						 ) where not exists (select 1 from acs_rels where object_id_one = :evaluation_group_id and object_id_two = :student_id and rel_type = 'evaluation_task_group_rel')),0); 
	
      </querytext>
</fullquery>

</queryset>
