# /packages/evaluation/www/admin/groups/group-remove-member.tcl

ad_page_contract {
	Deletes a task group

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	rel_id:integer,notnull
	task_id:integer,notnull
	evaluation_group_id:integer,notnull
}

db_exec_plsql delete_relationship { *SQL* }		

if { [string eq [db_string get_members { *SQL* }] 0] } {
    db_exec_plsql delete_group { *SQL* }
    ad_returnredirect "one-task?[export_vars -url { task_id }]"
}

ad_returnredirect "one-group?[export_vars -url { evaluation_group_id task_id }]"
