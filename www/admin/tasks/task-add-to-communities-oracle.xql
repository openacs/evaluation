<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_user_comunities">      
      <querytext>

    select dotlrn_communities_all.pretty_name, 
    dotlrn_communities_all.community_id,
    dotlrn_community.url(dotlrn_communities_all.community_id) as url
    from dotlrn_communities_all,
    dotlrn_member_rels_approved,
    dotlrn_classes
    where dotlrn_communities_all.community_id = dotlrn_member_rels_approved.community_id
    and dotlrn_communities_all.community_type = dotlrn_classes.class_key
    and dotlrn_member_rels_approved.user_id = :user_id
    and acs_permission.permission_p(dotlrn_communities_all.community_id, :user_id, 'admin') = 't'
    and dotlrn_communities_all.community_id <> [dotlrn_community::get_community_id]
    order by dotlrn_communities_all.pretty_name
	
      </querytext>
</fullquery>

<fullquery name="community_has_assignment_type">      
      <querytext>

	select eg.grade_item_id as to_grade_item_id from evaluation_gradesx eg, acs_objects ao
	where content_revision.is_live(eg.grade_id) = 't'
	and eg.item_id = ao.object_id
	and ao.context_id = :community_package_id
	and lower(eg.grade_name) = '[string tolower $grade_name]'
	
      </querytext>
</fullquery>

<fullquery name="task_grade_info">      
      <querytext>

	select et.task_name, eg.grade_name
	from evaluation_grades eg, evaluation_tasks et 
	where et.grade_item_id = eg.grade_item_id 
	and et.task_id = :task_id 
	and content_revision.is_live(eg.grade_id) = 't'
	
      </querytext>
</fullquery>

</queryset>
