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

#Callbacks for application-track

ad_proc -callback application-track::getApplicationName -impl evaluation {} { 
        callback implementation 
    } {
        return "evaluation"
    }    
ad_proc -callback application-track::getGeneralInfo -impl evaluation {} { 
        callback implementation 
    } {
    
	db_1row my_query {
	select count(1) as result
		from acs_objects a, acs_objects b
        	where b.object_id = :comm_id
	        and a.tree_sortkey between b.tree_sortkey
        	and tree_right(b.tree_sortkey)
	        and a.object_type = 'evaluation_tasks'	
	}
	return "$result"
    } 
    
ad_proc -callback application-track::getSpecificInfo -impl evaluation {} { 
        callback implementation 
    } {
   	
	upvar $query_name my_query
	upvar $elements_name my_elements

	set my_query {
		select e.task_name as name,e.task_id as task_id,e.number_of_members as number_elements
		from acs_objects a, acs_objects b,evaluation_tasks e
        	where b.object_id = :class_instance_id
	        and a.tree_sortkey between b.tree_sortkey
        	and tree_right(b.tree_sortkey)
	        and a.object_type = 'evaluation_tasks'
            	and e.task_id = a.object_id

	}
		
	set my_elements {
    		name {
	            label "Name"
	            display_col name	                        
	 	    html {align center}	 	    
	 	                
	        }
	        id {
	            label "Id"
	            display_col task_id 	      	              
	 	    html {align center}	 	               
	        }
	        number_elements {
	            label "Number of elements"
	            display_col number_elements 	      	               
	 	    html {align center}	 	              
	        }            
	      
	    
	}
    }         

