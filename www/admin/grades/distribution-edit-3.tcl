# /packages/evaluation/www/admin/grades/distribution-edit-2.tcl

ad_page_contract { 
    Bulk edit a set tasks
} { 
    grade_id:naturalnum,notnull
    {equal_grade 0}
    {grade_sum 0}
    {diff 0}
}

db_1row grade_info {}
set tasks [db_list_of_lists get_grade_tasks {}]
set tasks_counter [llength $tasks]
set i 0

if { $tasks_counter > 0} {
    set equal_grade [format %0.2f [expr {100.00/$tasks_counter}]]
}


foreach task $tasks { 
    incr i
    set grade_sum [expr {$grade_sum + $equal_grade}]
    if {$tasks_counter eq $i} {
	set diff [expr {100-$grade_sum}]
    }
    set aweight [format %0.2f [expr ($equal_grade + $diff)]]
    set apoints [format %0.2f [expr ($aweight*$grade_weight)/100.0]]
    set id [lindex $task 3]
    set relative_weight [format %0.2f [expr ($tasks_counter*$aweight)/100.00]]
    db_dml update_task { *SQL* }
    
}


ad_returnredirect "distribution-edit?grade_id=$grade_id"

ad_script_abort


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
