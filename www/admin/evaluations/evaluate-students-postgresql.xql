<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_party_name">      
      <querytext>

			select evaluation__party_name(:party_id,:task_id)
	
      </querytext>
</fullquery>

</queryset>
