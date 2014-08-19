# /packages/evaluation/www/

ad_page_contract {
    Removes relations
    
    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    task_id:naturalnum,notnull
    grade_id:naturalnum,notnull
    operation
    return_url
} 

if {$operation eq [_ evaluation.lt_Yes_I_really_want_to__3]} {

    db_transaction {

	# calendar integration (begin)
	db_1row get_item_id { *SQL* }
	db_foreach cal_map { *SQL* } {
	    db_dml delete_mapping { *SQL* }
	    calendar::item::delete -cal_item_id $cal_item_id
	}
	# calendar integration (end)
        evaluation::delete_task -task_id $task_id 
	
    } on_error {
	ad_return_error "[_ evaluation.lt_Error_deleting_the_ta]" "[_ evaluation.lt_We_got_the_following__2]"
	ad_script_abort
    }
} else {
    if { $return_url eq "" } {
	# redirect to the index page by default
	set return_url "$return_url"
    }
}

db_release_unused_handles

ad_returnredirect "$return_url"
