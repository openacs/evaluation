<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_group_info">      
      <querytext>

		select acs_group.name(:evaluation_group_id) as group_name from dual
	
      </querytext>
</fullquery>

</queryset>
