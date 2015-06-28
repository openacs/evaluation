# /packages/evaluation/www/admin/groups/group-ember-add.tcl

ad_page_contract {
	Displays the group list in order to add a member to one of them.

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	student_id:naturalnum,notnull
	task_id:naturalnum,notnull
	{orderby:token,optional}
} -validate {
	target_exists {
		if { [string equal "select count(group_id) from evaluation_task_groups where task_id = :task_id" 0] } {
			ad_complain "[_ evaluation.lt_There_are_no_groups_f]"
		}
	}
}

set page_title "[_ evaluation.lt_Add_a_member_to_a_gro]"
set context [list [list "[export_vars -base one-task { task_id }]" "[_ evaluation.Task_Groups_]"] "[_ evaluation.Add_Member_to_group_]"]

set elements [list group_name \
				  [list label "[_ evaluation.Group_Name_]" \
					   orderby_asc {group_name asc} \
					   orderby_desc {group_name desc}] \
				  number_of_members \
				  [list label "[_ evaluation.No_of_members_]" \
					   orderby_asc {number_of_members asc} \
					   orderby_desc {number_of_members desc}] \
				  associate_to_group \
				  [list label "" \
					   link_url_col associate_to_group_url \
					   link_html { title "[_ evaluation.Associate_]" }] \
				  ]


template::list::create \
    -name evaluation_groups \
    -multirow evaluation_groups \
    -key evaluation_group_id \
    -filters { student_id {} task_id {} } \
    -elements $elements 

set orderby [template::list::orderby_clause -orderby -name evaluation_groups]

if {$orderby eq ""} {
    set orderby " order by group_name asc"
}

db_multirow -extend { associate_to_group_url associate_to_group } evaluation_groups get_evaluation_groups { *SQL* } {
	set associate_to_group_url [export_vars -base "group-member-add-2" -url { task_id student_id evaluation_group_id }]
	set associate_to_group "[_ evaluation.lt_Associate_to_this_gro]"
}




 