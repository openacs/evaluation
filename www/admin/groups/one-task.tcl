# /evaluation/www/admin/groups/one-task.tcl

ad_page_contract {
	Shows the students and gropus associated with a task.

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	task_id:integer,notnull
	{orderby:optional}
	{orderby_groups:optional}
	{return_url "one-task?[export_vars -url { task_id }]"}
} -validate {
	group_task {
		if { [string eq [db_string get_number_of_members { *SQL* }] 1] } {
			ad_complain "This task is not in groups"
		}
	}
}

db_1row get_info { *SQL* }

set page_title "Groups for task $task_name"
set context [list "Assignment Groups"]

# we have to decide if we are going to show all the users in the system
# or only the students of a given class (community in dotrln)
# in order to create the groups

set community_id [dotlrn_community::get_community_id]
if { [empty_string_p $community_id] } {
    set query_name get_students_without_group
} else {
    set query_name community_get_students_without_group
}

set elements [list associate \
				  [list label "" \
				   display_template { <input type=checkbox name=student_ids.@students_without_group.student_id@ value=@students_without_group.student_id@> } \
				   ] \
				  student_name \
				  [list label "Name" \
					   orderby_asc {student_name asc} \
					   orderby_desc {student_name desc}] \
				  associate_to_group \
				  [list label "" \
					   link_url_col associate_to_group_url \
					   link_html { title "Associate to group..." }] \
				  ]

template::list::create \
    -name students_without_group \
    -multirow students_without_group \
    -key student_id \
    -pass_properties { return_url student_id } \
    -filters { task_id {} } \
    -elements $elements 


set orderby [template::list::orderby_clause -orderby -name students_without_group]

if { [string equal $orderby ""] } {
    set orderby " order by student_name asc"
}

db_multirow -extend { associate_to_group_url associate_to_group } students_without_group $query_name { *SQL* } {
	set associate_to_group_url [export_vars -base "group-member-add" -url { task_id student_id }]
	set associate_to_group "Associate to group..."
}

set elements [list group_name \
				  [list label "Group Name" \
					   orderby_asc {group_name asc} \
					   orderby_desc {group_name desc}] \
				  members \
				  [list label "Members" \
					   display_template { @task_groups.members;noquote@ } \
					  ] \
				  number_of_members \
				  [list label "Total of Members" \
					   orderby_asc {number_of_members asc} \
					   orderby_desc {number_of_members desc}] \
				  group_administration \
				  [list label "" \
					   link_url_col group_administration_url \
					   link_html { title "Group administration" }] \
				 ]


template::list::create \
    -name task_groups \
    -multirow task_groups \
    -key evaluation_group_id \
    -pass_properties { return_url evaluation_group_id } \
    -filters { task_id {} } \
    -orderby_name orderby_groups \
    -elements $elements 


set orderby_groups [template::list::orderby_clause -orderby -name task_groups]

if { [string equal $orderby_groups ""] } {
    set orderby_groups " order by group_name asc"
}

db_multirow -extend { group_administration_url group_administration members } task_groups get_task_groups { *SQL* } {
	set group_administration_url [export_vars -base "one-group" -url { task_id evaluation_group_id }]
	set group_administration "Group administration"
	set members [join [db_list get_group_members { *SQL* }] "<br />"]
}

if { [db_string get_groups_for_task { *SQL* }] > 0 } {
	set reuse_link ""
} else {
	set reuse_link "<a href=\"[export_vars -base group-reuse { task_id }]\">Reuse groups from another task</a>"
}

ad_return_template


 