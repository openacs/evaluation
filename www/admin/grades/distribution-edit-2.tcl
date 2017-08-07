# /packages/evaluation/www/admin/grades/distribution-edit-2.tcl

ad_page_contract { 
    Bulk edit a set tasks
} { 
    grade_id:naturalnum,notnull
    no_grade:array
    weights:array
    {weight_sum "0"}
    {points_p:boolean "0"}
    {info ""}
    {relative_p:boolean 0}
} -validate {
    valid_weights {
	db_1row grade_info { *SQL* }
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
    weights_sum {
	set count 0
	foreach id [array names weights] { 
	    set count [expr {$count+$weights($id)}]
	}
	if { $count > 100} {
	    ad_complain "[_ evaluation.not_equal_100]"
	}
    }
}

if {$info eq "[_ evaluation.Over_total_grade]"} {
    set points_p 1
}

if {$info eq "[_ evaluation.rel_weight]"} {
    set relative_p 1
}

set without_grade [list]
set with_grade [list]
set counter 0

foreach id [array names weights] { 
    incr counter
}
foreach id [array names weights] { 
    # create a list of tasks that requieres/not requires grade
    if {$no_grade($id) == "t"} { 
	lappend with_grade $id
    } else { 
        lappend without_grade $id
    }
    set aweight [format %.2f $weights($id)]
    set apoints [format %0.2f [expr ($weights($id)*$grade_weight)/100.00]]
    set rel_weight [format %0.2f [expr ($counter*$aweight/100.00)]]

    db_dml update_task { *SQL* }
    
    if { [llength $with_grade] } {
	db_dml update_tasks_with_grade { *SQL* }
    } 
    if { [llength $without_grade] } { 
	db_dml update_tasks_without_grade { *SQL* }
    }      
}


ad_returnredirect "distribution-edit?grade_id=$grade_id"

ad_script_abort


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
