# /packages/evaluation/www/admin/groups/group-rename.tcl

ad_page_contract {
	Renames a group.

	@author jopez@galileo.edu
	@createion-date Mar 2004
	@cvs-id $Id$
} {
	task_id:integer,notnull
	evaluation_group_id:integer,notnull
}

set package_id [ad_conn package_id]
set page_title "New Group"
set context [list [list "[export_vars -base one-task { task_id }]" "Task Groups"] [list "[export_vars -base one-group { task_id evaluation_group_id }]" "One Group"] "Rename Group"]

set group_name [evaluation::evaluation_group_name -group_id $evaluation_group_id]

set export_vars [export_vars -form { task_id evaluation_group_id }]

