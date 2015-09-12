ad_library {
    Library of callbacks implementations for evaluation
}

ad_proc -callback application-track::getApplicationName -impl evaluation {} { 
        callback implementation 
    } {
        return "evaluation"
    }    
    ad_proc -callback application-track::getGeneralInfo -impl evaluation {} { 
        callback implementation 
    } {
    
	db_1row my_query {
	SELECT count(1) as result
                FROM evaluation_tasks e,dotlrn_communities_full com,acs_objects o, acs_objects o2
		WHERE e.task_id = o.object_id
        	      and com.community_id=:comm_id
		      and o.package_id= o2.object_id
		      and o2.context_id=com.package_id	
	        
	        
	        
	        
	}
	return "$result"
    } 
    
     ad_proc -callback application-track::getSpecificInfo -impl evaluation {} { 
        callback implementation 
    } {
   	
	upvar $query_name my_query
	upvar $elements_name my_elements

	set my_query {
		select e.task_name as name,e.task_id as task_id,e.number_of_members as number_elements,c.description as type
		FROM evaluation_tasks e,dotlrn_communities_full com,acs_objects o, acs_objects o2,cr_revisions c
		WHERE e.task_id = o.object_id
        	      and com.community_id=:class_instance_id
		      and o.package_id= o2.object_id
		      and o2.context_id=com.package_id
            	      and e.grade_item_id = c.item_id

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
	        type_evaluation {
	            label "Type"
	            display_col type 	      	               
	 	    html {align center}
	 	}
	        number_elements {
	            label "Number of elements"
	            display_col number_elements 	      	               
	 	    html {align center}	 	              
	        }
	      	 	              
	                       
	      
	    
	}
    }         
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
