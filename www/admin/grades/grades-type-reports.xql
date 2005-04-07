<?xml version="1.0"?>

<queryset>

<fullquery name="grade_task">      
      <querytext>

	    select et.task_id, 
		et.task_name,
		et.weight
   	    from evaluation_tasksi et, evaluation_grades eg, cr_items cri
		where cri.live_revision = et.task_id
   		  and eg.grade_id = :grade_id
	          and eg.grade_item_id = et.grade_item_id
	    order by task_name

      </querytext>
</fullquery>

<fullquery name="get_grades">      
      <querytext>

		select cu.first_names||', '||cu.last_name as student_name,
		cu.user_id
		$sql_query
   	 	from cc_users cu 
		$orderby

      </querytext>
</fullquery>

<fullquery name="community_get_grades">      
      <querytext>

		select cu.first_names||', '||cu.last_name as student_name,
		cu.user_id
		$sql_query
   	 	from cc_users cu,
	        dotlrn_member_rels_approved app
	    where app.community_id = :community_id
	      and app.user_id = cu.person_id
	      and app.role = 'student'		
		$orderby

      </querytext>
</fullquery>

</queryset>

