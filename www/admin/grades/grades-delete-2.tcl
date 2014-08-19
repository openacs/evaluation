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

if {$operation eq "[_ evaluation.lt_Yes_I_really_want_to__1]"} {
    db_transaction {

	# calendar integration (begin)
	db_foreach cal_map { *SQL* } {
	    db_dml delete_mapping { *SQL* }
	    calendar::item::delete -cal_item_id $cal_item_id
	}
	# calendar integration (end)
        evaluation::delete_grade -grade_id $grade_id 
	
    } on_error {
	ad_return_error "[_ evaluation.lt_Error_deleting_the_gr]" "[_ evaluation.lt_We_got_the_following__1]"
	ad_script_abort
    }
} else {
    if { $return_url eq "" } {
	# redirect to the index page by default
	set return_url "grades"
    }
}

db_release_unused_handles

ad_returnredirect $return_url
