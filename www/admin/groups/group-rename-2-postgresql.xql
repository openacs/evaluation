<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="rename_group">      
      <querytext>

		update groups set group_name = :group_name
		where group_id = :evaluation_group_id

      </querytext>
</fullquery>

</queryset>
