<?xml version="1.0"?>

<queryset>
<fullquery name="get_task_info">      
      <querytext>

	    select task_name, task_item_id,
		number_of_members
        from evaluation_tasks et 
        where task_id=:task_id

      </querytext>
</fullquery>

<fullquery name="file_exists">      
      <querytext>

		select count(*) from cr_items where item_id = :grades_sheet_item_id

      </querytext>
</fullquery>

<fullquery name="task_group">      
      <querytext>

	select count(*) from evaluation_task_groups etg where group_id = :party_id and task_item_id = :task_item_id

      </querytext>
</fullquery>

<fullquery name="valid_user">      
      <querytext>

	select count(*) from cc_users where person_id = :party_id

      </querytext>
</fullquery>

<fullquery name="valid_student">      
      <querytext>

	select count(*) 
	from persons p,
	registered_users ru,
               dotlrn_member_rels_approved app
	       where app.community_id = :community_id
               and app.user_id = ru.user_id
	       and app.user_id = p.person_id
               and app.user_id = :party_id
	       and app.role = 'student'

      </querytext>
</fullquery>

<fullquery name="get_item_id">      
      <querytext>

		select item_id from evaluation_student_evalsi where evaluation_id = :evaluation_id

      </querytext>
</fullquery>

</queryset>
