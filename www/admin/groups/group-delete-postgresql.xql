<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_group_info">      
      <querytext>

		select acs_group__name(:evaluation_group_id) as group_name
	
      </querytext>
</fullquery>

</queryset>
