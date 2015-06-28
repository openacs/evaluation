# /packages/evaluation/www/admin/groups/group-rename.tcl

ad_page_contract {
	Renames a group.

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	evaluation_group_id:naturalnum,notnull
	task_id:naturalnum,notnull
	group_name:notnull
}

db_dml rename_group { *SQL* }		

ad_returnredirect [export_vars -base one-group { task_id evaluation_group_id }]

