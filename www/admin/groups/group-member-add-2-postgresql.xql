<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="associate_student">      
      <querytext>

	select acs_rel__new (
						 null,
						 'evaluation_task_group_rel',
						 :evaluation_group_id,
						 :student_id,
						 :package_id,
						 :creation_user_id,
						 :creation_ip
						 );
	
      </querytext>
</fullquery>

</queryset>
