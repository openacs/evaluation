# /packages/evaluation/www/

ad_page_contract {
    Removes relations
    
    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    grade_id:integer,notnull
    return_url
	operation
} 

if { [string eq $operation "[_ evaluation.lt_Yes_I_really_want_to__1]"] } {
    db_transaction {

		db_exec_plsql delete_grade { *SQL* }		
		
    } on_error {
		ad_return_error "[_ evaluation.lt_Error_deleting_the_gr]" "[_ evaluation.lt_We_got_the_following__1]"
		ad_script_abort
    }
} else {
    if { [empty_string_p $return_url] } {
		# redirect to the index page by default
		set return_url "grades"
    }
}

db_release_unused_handles

ad_returnredirect $return_url