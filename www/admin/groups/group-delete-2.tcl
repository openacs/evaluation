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

if { [string eq $operation "[_ evaluation.lt_Yes_I_really_want_to__2]"] } {
    db_transaction {

		db_exec_plsql delete_group { *SQL* }		

		
    } on_error {
		ad_return_error "[_ evaluation.lt_Error_deleting_the_ev]" "[_ evaluation.lt_We_got_the_following_]"
		ad_script_abort
    }
}

db_release_unused_handles

# redirect to the index page by default

ad_returnredirect "one-task?[export_vars -url { task_id }]"