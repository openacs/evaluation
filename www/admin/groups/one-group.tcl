# /packages/evaluation/www/admin/groups/one-group.tcl

ad_page_contract {
	Shows the members of a group and options to edit the group

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	task_id:integer
	evaluation_group_id:integer
	{orderby:optional}
}

set number_of_members [db_string get_no_of_members { *SQL* }]

set page_title "One Group"
set context [list [list "[export_vars -base one-task { task_id }]" "Task Groups"] "One Group"]

if { $number_of_members } {
	set group_name [evaluation::evaluation_group_name -group_id $evaluation_group_id]
	append page_title ": $group_name"
}


set actions [list "Delete Group" [export_vars -base "group-delete" { evaluation_group_id task_id }]  {}]

set elements [list student_name \
				  [list label "Student Name" \
					   orderby_asc {student_name asc} \
					   orderby_desc {student_name desc}] \
				  unassociate_member \
				  [list label "" \
					   link_url_col unassociate_member_url \
					   link_html { title "Unassociate student for this group" }] \
				 ]

template::list::create \
    -name one_group \
    -multirow one_group \
	-key group_id \
	-pass_properties { return_url evaluation_group_id } \
	-filters { task_id {} evaluation_group_id {} } \
	-actions $actions \
    -elements $elements 

set orderby [template::list::orderby_clause -orderby -name one_group]

if { [string equal $orderby ""] } {
    set orderby " order by student_name asc"
}

db_multirow -extend { unassociate_member_url unassociate_member } one_group get_group_members { *SQL* } {
	set unassociate_member_url [export_vars -base "group-remove-member" -url { evaluation_group_id task_id rel_id }]
	set unassociate_member "Unassociate member"
}

set export_vars [export_vars -form { task_id evaluation_group_id }]

ad_return_template


