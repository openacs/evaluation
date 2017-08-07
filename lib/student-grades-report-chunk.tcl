ad_page_contract {

    task chunk to be displayed in the index page

}

db_1row grade_names { *SQL* }
set package_id [ad_conn package_id]
set base_url [ad_conn package_url]

set mode display
set return_url [export_vars -base [ad_conn url] { grade_id }]

db_1row grade_info { *SQL* }

set elements [list task_name \
		  [list label "[_ evaluation.Task_Name_]" \
		       orderby_asc {task_name asc} \
		       orderby_desc {task_name desc}] \
		  task_status \
		  [list label "[_ evaluation.Task_Status_]" \
		      ] \
		  due_date_pretty \
		  [list label "[_ evaluation.Due_date_]" \
		       orderby_asc {due_date_ansi asc} \
		       orderby_desc {due_date_ansi desc}] \
		  grade \
		  [list label "[_ evaluation.lt_Grade_over_100_points]" \
		       orderby_asc {grade asc} \
		       orderby_desc {grade desc}] \
		  net_grade \
		  [list label "[_ evaluation.Grade_in_Net_value_]" \
		       orderby_asc {net_grade asc} \
		       orderby_desc {net_grade desc}] \
		  online_p \
		  [list label "[_ evaluation.Online_Submit_]" \
		       orderby_asc {online_p asc} \
		       orderby_desc {online_p desc}] \
		  assignment_group \
		  [list label "[_ evaluation.Assignment_Group_]" \
		       orderby_asc {assignment_group asc} \
		       orderby_desc {assignment_group desc}] \
		  grader_name \
		  [list label "[_ evaluation.Grader_]" \
		       orderby_asc {grader_name asc} \
		       orderby_desc {grader_name desc}] \
		  comments \
		  [list label "[_ evaluation.Comments_]" \
		       orderby_asc {comments asc} \
		       orderby_desc {comments desc}] \
		 ]

template::list::create \
    -name student_grades \
    -multirow student_grades \
    -pass_properties { return_url base_url } \
    -filters { grade_id {} student_id {} } \
    -elements $elements \
    -no_data "[_ evaluation.No_assignments_]" \
    -orderby_name orderby \
    -orderby { default_value task_name }

set orderby [template::list::orderby_clause -orderby -name student_grades]

if {$orderby eq ""} {
    set assignments_orderby " order by task_name asc"
}

set max_grade 0.00
set total_grade 0.00

db_multirow -extend { task_status due_date_pretty assignment_group grade net_grade grader_name comments } student_grades get_student_grades { *SQL* } {

    set due_date_pretty  [lc_time_fmt $due_date_ansi "%q %r"]

    if { $online_p } {
	set online_p "[_ evaluation.Yes_]"
    } else {
	set online_p "[_ evaluation.No_]"
    }
    
    set over_weight ""
    set task_status ""

    # working with answer stuff (if it has a file/url attached)	
    set answer_id ""
    db_0or1row get_answer_data { *SQL* }

    if { $answer_id eq "" } {
	append task_status " [_ evaluation.Not_answered_] "
    } else {
	append task_status " [_ evaluation.Already_answered_] "
    }

    # working with grade stuff (if there is any)
    set grade ""
    set comments ""
    db_0or1row get_grade_info { *SQL* }

    if { $grade ne "" } {

	set grade [lc_numeric $grade]
	set over_weight "[lc_numeric $net_grade]/"
	set total_grade [expr {$total_grade + $net_grade}]
	set net_grade [lc_numeric $net_grade]
	set task_status "[_ evaluation.Evaluated_]"
    } else {
	set net_grade "[_ evaluation.na_]"
	set grade "[_ evaluation.na_]"
	set grader "[_ evaluation.na_]"
	append task_status " [_ evaluation.Not_evaluated_] "
    }
	    
    if { $comments eq "" } {
	set comments "[_ evaluation.na_]"
    }

    set max_grade [expr {$task_weight + $max_grade}] 

    set task_weight "${over_weight}[lc_numeric $task_weight]"
    
    set group_id [db_string get_group_id { *SQL* }]
    if { $number_of_members > 1 } {
	if {$group_id eq "0"} {
	    set task_status "[_ evaluation.lt_No_group_for_student_]"
	    set assignment_group " [_ evaluation.na_] "
	} else {
	    set assignment_group [db_string group_name { *SQL* }] 
	}
    } else {
	set assignment_group "[_ evaluation.Individual_]"
    }
    
}

set total_grade [lc_numeric [expr {$total_grade}]]
set max_grade [lc_numeric $max_grade]
set grade_weight [lc_numeric $grade_weight]
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
