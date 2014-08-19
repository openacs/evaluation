# /packages/evaluation/www/admin/groups/one-group.tcl

ad_page_contract {
	Shows the members of a group and options to edit the group

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	task_id:naturalnum,notnull
	evaluation_group_id:naturalnum,notnull
	{orderby:optional}
}

set number_of_members [db_string get_no_of_members { *SQL* }]

set page_title "[_ evaluation.One_Group_]"
set context [list [list "[export_vars -base one-task { task_id }]" "[_ evaluation.Task_Groups_]"] "[_ evaluation.One_Group_]"]

if { $number_of_members } {
	set group_name [evaluation::evaluation_group_name -group_id $evaluation_group_id]
	append page_title ": $group_name"
}

set return_url "[ad_conn url]?[export_vars -url { evaluation_group_id task_id }]"

set actions [list "[_ evaluation.Delete_Group_]" [export_vars -base "group-delete" { evaluation_group_id task_id return_url }]  {}]

set elements [list student_name \
		  [list label "[_ evaluation.Student_Name_]" \
		       orderby_asc {student_name asc} \
		       orderby_desc {student_name desc}] \
		  unassociate_member \
		  [list label "" \
		       link_url_col unassociate_member_url \
		       link_html { title "[_ evaluation.lt_Unassociate_student_f]" }] \
		 ]

template::list::create \
    -name one_group \
    -multirow one_group \
    -key group_id \
    -pass_properties { evaluation_group_id } \
    -filters { task_id {} evaluation_group_id {} } \
    -actions $actions \
    -elements $elements 

set orderby [template::list::orderby_clause -orderby -name one_group]

if {$orderby eq ""} {
    set orderby " order by student_name asc"
}

db_multirow -extend { unassociate_member_url unassociate_member } one_group get_group_members { *SQL* } {
	set unassociate_member_url [export_vars -base "group-remove-member" -url { evaluation_group_id task_id rel_id }]
	set unassociate_member "[_ evaluation.Unassociate_member_]"
}

set export_vars [export_vars -form { task_id evaluation_group_id }]

ad_return_template


