<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="delete_relationship">      
      <querytext>

	select acs_rel__delete (
							:rel_id
							);

      </querytext>
</fullquery>

<fullquery name="get_members">      
      <querytext>

	select count(*) from acs_rels where object_id_one = :evaluation_group_id

      </querytext>
</fullquery>

<fullquery name="delete_group">      
      <querytext>

 	select evaluation__delete_evaluation_task_group (
							 :evaluation_group_id
							 );
    
      </querytext>
</fullquery>

</queryset>
