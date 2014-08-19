# /packabes/evaluation/www/admin/groups/group-delete-2.tcl

ad_page_contract {
	Deletes a task group

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	evaluation_group_id:naturalnum,notnull
	task_id:naturalnum,notnull
	operation
	return_url
}

if {$operation eq "[_ evaluation.lt_Yes_I_really_want_to__2]"} {
    db_transaction {

		evaluation::delete_evaluation_group -group_id $evaluation_group_id
		
    } on_error {
		ad_return_error "[_ evaluation.lt_Error_deleting_the_ev]" "[_ evaluation.lt_We_got_the_following_]"
		ad_script_abort
    }
} else {
	# it is a "don't do anything" request
	ad_returnredirect $return_url
}

db_release_unused_handles

ad_returnredirect "one-task?[export_vars -url { task_id }]"
