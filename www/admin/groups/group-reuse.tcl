# /packages/evaluation/www/admin/groups/group-reuse.tcl

ad_page_contract {
	Page for reusing evaluation groups

	@author jopez@galileo.edu
	@creation-date Apr 2004
	@cvs-id $Id$
} {
	task_id:naturalnum,notnull
	{orderby:optional}
}

set package_id [ad_conn package_id]
set page_title "[_ evaluation.Reuse_Groups_]"
set context [list [list "[export_vars -base one-task { task_id }]" "[_ evaluation.Task_Groups_]"] "[_ evaluation.Reuse_Groups_]"]

set elements [list task_name \
		  [list label "[_ evaluation.Group_Name_]" \
		       link_url_col task_url \
		       orderby_asc {task_name asc} \
		       orderby_desc {task_name desc}] \
		  number_of_members \
		  [list label "[_ evaluation.No_of_Members_]" \
		       orderby_asc {number_of_members asc} \
		       orderby_desc {number_of_members desc}] \
		  grade_plural_name \
		  [list label "[_ evaluation.Assignment_Type_]" \
		       orderby_asc {grade_plural_name asc} \
		       orderby_desc {grade_plural_name desc}] \
		 ]

template::list::create \
	-name groups \
	-multirow groups \
	-filters { task_id {} } \
	-elements $elements

	
set orderby [template::list::orderby_clause -orderby -name groups]
	
if {$orderby eq ""} {
	set orderby " order by et.task_name asc"
}

db_multirow -extend { task_url } groups get_groups { *SQL* } {
	set task_url [export_vars -base group-reuse-2 { from_task_id task_id }]
}

 