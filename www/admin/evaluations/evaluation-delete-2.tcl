# /packages/evaluation/www/admin/evaluations/evaluation-delete-2.tcl

ad_page_contract {
    Removes relations
    
    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    evaluation_id:integer,notnull
	task_id:integer,notnull
	operation
} 

if { [string eq $operation "[_ evaluation.lt_Yes_I_really_want_to_]"] } {
    db_transaction {

		db_exec_plsql delete_evaluation { *SQL* }		
		
    } on_error {
		ad_return_error "[_ evaluation.lt_Error_deleting_the_ev]" "[_ evaluation.lt_We_got_the_following_]"
		ad_script_abort
    }
}

db_release_unused_handles

# redirect to the index page by default
ad_returnredirect "student-list?[export_vars -url { task_id }]"
