<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="delete_relationship">      
      <querytext>

	select acs_rel__delete (
							:rel_id
							);

      </querytext>
</fullquery>

</queryset>
