# /packages/evaluation/www/admin/grades/distribution-edit-2.tcl

ad_page_contract { 
    Bulk edit a set tasks
} { 
    grade_id:integer,notnull
    no_grade:array
    weights:array
} -validate {
    valid_weights {
		foreach id [array names weights] { 
			if { ![info exists weights($id)] } {
				ad_complain "The task weight can't be null"
			} else {
				if { ![ad_var_type_check_number_p $weights($id)] } {
					ad_complain "The task weight $weights($id) must be a valid number"
				}
			}
		}
    }
}
   
set without_grade [list]
set with_grade [list]
foreach id [array names weights] { 
    # create a list of tasks that requieres/not requires grade
	if { [string eq $no_grade($id) "t"] } { 
		lappend with_grade $id
    } else { 
        lappend without_grade $id
	}
    
	set aweight $weights($id)

	db_dml update_task { *SQL* }

	if { [llength $with_grade] } {
		db_dml update_tasks_with_grade { *SQL* }
	} 
	if { [llength $without_grade] } { 
		db_dml update_tasks_without_grade { *SQL* }
	}      
}


ad_returnredirect "grades"

ad_script_abort

