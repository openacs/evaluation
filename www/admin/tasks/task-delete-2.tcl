# /packages/evaluation/www/

ad_page_contract {
    Removes relations
    
    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    task_id:integer,notnull
	grade_id:integer,notnull
	operation
	return_url
} 

if { [string eq $operation [_ evaluation.lt_Yes_I_really_want_to__3]] } {
    db_transaction {

		db_exec_plsql delete_task { *SQL* }		
		
    } on_error {
		ad_return_error "[_ evaluation.lt_Error_deleting_the_ta]" "[_ evaluation.lt_We_got_the_following__2]"
		ad_script_abort
    }
} else {
    if { [empty_string_p $return_url] } {
		# redirect to the index page by default
		set return_url "$return_url"
    }
}

db_release_unused_handles

ad_returnredirect "$return_url"
