# /packages/evaluation/www/admin/groups/group-rename-2.tcl

ad_page_contract {
	Renames a group.

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	evaluation_group_id:integer
	task_id:integer
	group_name:notnull
}

db_dml rename_group { *SQL* }		

ad_returnredirect "one-group?[export_vars -url { task_id evaluation_group_id }]"
