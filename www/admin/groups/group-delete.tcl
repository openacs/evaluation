# /packages/evaluation/www/admin/groups/group-delete.tcl

ad_page_contract {
	Asks for a confirmation before deleting the group

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	evaluation_group_id:integer
	task_id:integer
}

set page_title "Delete Evaluation"
set context [list [list "[export_vars -base one-task { task_id }]" "Task Groups"] [list "[export_vars -base one-group { task_id evaluation_group_id }]" "One Group"] "Delete Group"]

db_1row get_group_info { *SQL* }

set export_vars [export_vars -form { evaluation_group_id task_id }]


