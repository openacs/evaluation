<?xml version="1.0"?>

<queryset>

<fullquery name="rename_group">      
      <querytext>

		update groups set group_name = :group_name
		where group_id = :evaluation_group_id

      </querytext>
</fullquery>

</queryset>
