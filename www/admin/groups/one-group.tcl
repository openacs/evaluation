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


set actions [list "Delete Group" [export_vars -base "group-delete" { evaluation_group_id task_id }]  {} \
				 "Rename Group" [export_vars -base "group-rename" { evaluation_group_id task_id }]  {}
			]

set elements [list student_name \
				  [list label "Student Name" \
					   orderby_asc {student_name asc} \
					   orderby_desc {student_name desc}] \
				  desassociate_member \
				  [list label "" \
					   link_url_col desassociate_member_url \
					   link_html { title "Desassociate student for this group" }] \
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

db_multirow -extend { desassociate_member_url desassociate_member } one_group get_group_members { *SQL* } {
	set desassociate_member_url [export_vars -base "group-remove-member" -url { evaluation_group_id task_id rel_id }]
	set desassociate_member "Desassociate member"
}

ad_return_template


