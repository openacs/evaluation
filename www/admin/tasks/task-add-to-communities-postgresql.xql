<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_user_comunities">      
      <querytext>

    select dotlrn_communities_all.pretty_name, 
    dotlrn_communities_all.community_id,
    dotlrn_community__url(dotlrn_communities_all.community_id) as url
    from dotlrn_communities_all,
    dotlrn_member_rels_approved,
    dotlrn_classes
    where dotlrn_communities_all.community_id = dotlrn_member_rels_approved.community_id
    and dotlrn_communities_all.community_type = dotlrn_classes.class_key
    and dotlrn_member_rels_approved.user_id = :user_id
    and acs_permission__permission_p(dotlrn_communities_all.community_id, :user_id, 'admin') = true
    and dotlrn_communities_all.community_id <> [dotlrn_community::get_community_id]
    order by dotlrn_communities_all.pretty_name
	
      </querytext>
</fullquery>

<fullquery name="community_has_assignment_type">      
      <querytext>

	select eg.grade_id as to_grade_id from evaluation_gradesx eg, acs_objects ao
	where content_revision__is_live(eg.grade_id) = true
	and eg.item_id = ao.object_id
	and ao.context_id = :community_package_id
	and lower(eg.grade_name) = '[string tolower $grade_name]'
	
      </querytext>
</fullquery>

</queryset>
