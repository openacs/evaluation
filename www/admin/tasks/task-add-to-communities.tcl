# /packages/evaluation/www/admin/tasks/task-add-to-communities

ad_page_contract {
    Page for adding the same task to multiple communities.

    @author jopez@galileo.edu
    @creation-date Jun 2004
    @cvs-id $Id$
} {
    return_url:notnull
    task_id:integer,notnull
    communities_packages_ids:array,optional
    item_ids:array,optional
    {redirect_to_groups_p 0}
    foo:optional
}

set user_id [ad_conn user_id]
set this_package_id [ad_conn package_id]
set page_title "[_ evaluation.lt_Add_Assignment_to_Com]"

db_1row task_grade_info { *SQL* }

set context [list [list [export_vars -base grades { communities_packages_ids }] "[_ evaluation.Add_Assignment_]"] $page_title]

ad_form -name communities -cancel_url $return_url -export { return_url task_id } -form { foo:key }

set form_elements [list]
set communities_count 0
db_foreach get_user_comunities { *SQL* } {

    array set community_info [site_node::get -url "${url}[apm_package_key_from_id $this_package_id]"]
    set community_package_id $community_info(package_id)
    
    if { [db_0or1row community_has_assignment_type { *SQL* }] } {

 	lappend form_elements [list communities_packages_ids.$community_package_id:integer(checkbox),optional \
 				   [list label "$pretty_name"] \
 				   [list options [list [list "" "$to_grade_id"]]] \
				  ]
	incr communities_count
	if { [ad_form_new_p -key foo] } {
	    lappend form_elements [list item_ids.$community_package_id:integer(hidden) \
				       [list value [db_nextval acs_object_id_seq]] \
				       ]
	}
    }
} if_no_rows {
    ad_returnredirect $return_url
    ad_script_abort    
}

ad_form -extend -name communities -form $form_elements
ad_form -extend -name communities -on_submit {
    
    foreach id [array names communities_packages_ids] {
	set revision_id [evaluation::clone_task -item_id $item_ids($id) -from_task_id $task_id -to_grade_id $communities_packages_ids($id) -to_package_id $id]
	evaluation::set_live -revision_id $revision_id
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
