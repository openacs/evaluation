# /packabes/evaluation/www/admin/groups/group-delete-2.tcl

ad_page_contract {
	Deletes a task group

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	evaluation_group_id:integer
	task_id:integer
	operation
}

if { [string eq $operation "Yes, I really want to remove this group"] } {
    db_transaction {

		db_exec_plsql delete_group { *SQL* }		

		
    } on_error {
		ad_return_error "Error deleting the evaluation" "We got the following error while trying to remove the evaluation: <pre>$errmsg</pre>"
		ad_script_abort
    }
}

db_release_unused_handles

# redirect to the index page by default

ad_returnredirect "one-task?[export_vars -url { task_id }]"
