# /packages/evaluation/www/admin/groups/group-remove-member.tcl

ad_page_contract {
	Deletes a task group

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	rel_id:naturalnum,notnull
	task_id:naturalnum,notnull
	evaluation_group_id:naturalnum,notnull
}

db_exec_plsql delete_relationship { *SQL* }		

if {[db_string get_members { *SQL* }] eq "0"} {
    db_exec_plsql delete_group { *SQL* }
    ad_returnredirect [export_vars -base one-task { task_id }]
}

ad_returnredirect [export_vars -base one-group { evaluation_group_id task_id }]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
