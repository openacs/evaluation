# /packages/evaluation/www/admin/groups/group-ember-add.tcl

ad_page_contract {
	Displays the group list in order to add a member to one of them.

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	student_id:integer,notnull
	task_id:integer,notnull
	{orderby:optional}
} -validate {
	target_exists {
		if { [string eq "select count(group_id) from evaluation_task_groups where task_id = :task_id" 0] } {
			ad_complain "There are no groups for this task yet."
		}
	}
}

set page_title "Add a member to a group"
set context [list [list "[export_vars -base one-task { task_id }]" "Task Groups"] "Add Member to group"]

set elements [list group_name \
				  [list label "Group Name" \
					   orderby_asc {group_name asc} \
					   orderby_desc {group_name desc}] \
				  number_of_members \
				  [list label "No. of members" \
					   orderby_asc {number_of_members asc} \
					   orderby_desc {number_of_members desc}] \
				  associate_to_group \
				  [list label "" \
					   link_url_col associate_to_group_url \
					   link_html { title "Associate" }] \
				  ]


template::list::create \
    -name evaluation_groups \
    -multirow evaluation_groups \
	-key evaluation_group_id \
	-filters { student_id {} task_id {} } \
    -elements $elements 

set orderby [template::list::orderby_clause -orderby -name evaluation_groups]

if { [string equal $orderby ""] } {
    set orderby " order by group_name asc"
}

db_multirow -extend { associate_to_group_url associate_to_group } evaluation_groups get_evaluation_groups { *SQL* } {
	set associate_to_group_url [export_vars -base "group-member-add-2" -url { task_id student_id evaluation_group_id }]
	set associate_to_group "Associate to this group"
}




 