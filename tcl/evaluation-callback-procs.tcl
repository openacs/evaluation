ad_library {
    Callbacks implementations for evaluation
    
    @creation-date Jul 19 2005
    @author Enrique Catalan (quio@galileo.edu)
    @cvs-id $Id$
}

ad_proc -callback merge::MergeShowUserInfo -impl evaluation {
    -user_id:required
} {
    Show the evaluation items of user_id
} {
    set msg "Evaluation items"
    set result [list $msg]
    ns_log Notice $msg
    
    lappend result [list "Answers: [db_list sel_answers { *SQL* }] "]
    lappend result [list "Evals: [db_list_of_lists sel_evals { *SQL* }] "]
    
    return $result
}

ad_proc -callback merge::MergePackageUser -impl evaluation {
    -from_user_id:required
    -to_user_id:required
} {
    Merge the entries of two users.
    The from_user_id is the user_id of the user
    that will be deleted and all the items
    of this user will be mapped to the to_user_id.
} {
    set msg "Merging evaluation"
    set result [list $msg]
    ns_log Notice $msg
    
    db_transaction {
	db_dml upd_from_answers { *SQL* }
	db_dml upd_from_stud_evals { *SQL* }
    }  
    
    lappend result "Evaluation merge is done"
}


