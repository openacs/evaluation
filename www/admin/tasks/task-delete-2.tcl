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

if { [string eq $operation "Yes, I really want to remove this task"] } {
    db_transaction {

		db_exec_plsql delete_task { *SQL* }		
		
    } on_error {
		ad_return_error "Error deleting the task" "We got the following error while trying to remove the task: <pre>$errmsg</pre>"
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
