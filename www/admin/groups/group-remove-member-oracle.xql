<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="delete_relationship">      
      <querytext>

    begin
	acs_rel.del (:rel_id);
    end;

      </querytext>
</fullquery>

<fullquery name="get_members">      
      <querytext>

	select count(*) from acs_rels where object_id_one = :evaluation_group_id

      </querytext>
</fullquery>

<fullquery name="delete_group">      
      <querytext>

    begin
 	:1 := evaluation.delete_evaluation_task_group (
							 :evaluation_group_id
							 );
    end;

      </querytext>
</fullquery>

</queryset>
