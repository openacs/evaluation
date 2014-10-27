# /packages/evaluation/www/admin/evaluations/evaluation-delete-2.tcl

ad_page_contract {
    Removes relations
    
    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    evaluation_id:naturalnum,notnull
	task_id:naturalnum,notnull
	operation
} 

if {$operation eq [_ evaluation.lt_Yes_I_really_want_to_]} {
    db_transaction {
        evaluation::delete_student_eval -evaluation_id $evaluation_id
    } on_error {
		ad_return_error "[_ evaluation.lt_Error_deleting_the_ev]" "[_ evaluation.lt_We_got_the_following_]"
		ad_script_abort
    }
}

db_release_unused_handles

# redirect to the index page by default
ad_returnredirect "student-list?[export_vars -url { task_id }]"
