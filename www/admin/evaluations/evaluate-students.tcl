# /packages/evaluation/www/admin/evaluations/evaluate-students.tcl

ad_page_contract { 
    This page asks for an evaluation confirmation 
    
    @author jopez@galileo.edu 
    @creation-date Mar 2004
    @cvs-id $Id$
} { 
    task_id:naturalnum,notnull
    max_grade:integer,notnull
    item_ids:array,integer,optional
    item_to_edit_ids:array,integer,optional
    
    grades:array,optional
    reasons:array,optional
    show_student:array,optional
    evaluation_ids:array,integer,optional

    grades_wa:array,optional
    comments_wa:array,optional
    show_student_wa:array,optional

    grades_na:array,optional
    comments_na:array,optional
    show_student_na:array,optional

    {grade_all ""}
} -validate {
    valid_grades_wa {
	set counter 0
	foreach party_id [array names grades_wa] {
	    if { [info exists grades_wa($party_id)] && $grades_wa($party_id) ne "" } {
		incr counter
		set grades_wa($party_id) [util::trim_leading_zeros $grades_wa($party_id)]
		if { ![ad_var_type_check_number_p $grades_wa($party_id)] } {
		    set wrong_grade $grades_wa($party_id)
		    ad_complain "[_ evaluation.lt_The_grade_must_be_a_v]"
		}
	    }
	}
	if { !$counter && ([array size show_student_wa] > 0) } {
	    ad_complain "[_ evaluation.lt_There_must_be_at_leas]"
	}
    }
    valid_grades_na {
	set counter 0
	foreach party_id [array names grades_na] {
	    if { $grade_all eq "" } {
		if { [info exists grades_na($party_id)] && $grades_na($party_id) ne "" } {
		    incr counter
		    set grades_na($party_id) [util::trim_leading_zeros $grades_na($party_id)]
		    if { ![ad_var_type_check_number_p $grades_na($party_id)] } {
			set wrong_grade $grades_na($party_id)
			ad_complain "[_ evaluation.lt_The_grade_must_be_a_v]"
		    }
		}
	    } else {
		set grades_na($party_id) 0
	    }
	}
	if { !$counter && ([array size show_student_na] > 0) && $grade_all eq "" } {
	    ad_complain "[_ evaluation.lt_There_must_be_at_leas]"
	}
    }
    valid_grades {
	set counter 0
	foreach party_id [array names grades] {
	    if { [info exists grades($party_id)] && $grades($party_id) ne "" } {
		set grades($party_id) [util::trim_leading_zeros $grades($party_id)]
		if { ![ad_var_type_check_number_p $grades($party_id)] } {
		    set wrong_grade $grades($party_id)
		    ad_complain "[_ evaluation.lt_The_grade_most_be_a_v]"
		} else {			
		    set old_grade [format %.2f [db_string get_old_grade { *SQL* }]]
		    if { ![string equal $old_grade [format %.2f [expr {$grades($party_id)*100/$max_grade}]]] } {
			incr counter
			if { $max_grade != 100  } {
			    append reasons($party_id) "[_ evaluation.Weight_change]"
			}
			if { ![info exists reasons($party_id)] || $reasons($party_id) eq "" } {
			    set grade_wo_reason $grades($party_id)
			    ad_complain "[_ evaluation.lt_You_must_give_an_edit]"
			}
			set grades_to_edit($party_id) $grades($party_id)
			set reasons_to_edit($party_id) $reasons($party_id)
			set show_student_to_edit($party_id) $show_student($party_id)				
		    }
		}
	    }
	}
	if { !$counter && ([array size show_student] > 0) && ($max_grade == 100) } {
	    ad_complain "[_ evaluation.lt_There_must_be_at_leas]"
	}
    }
    valid_data {
	foreach party_id [array names comments_wa] {
	    if { [info exists comments_wa($party_id)] && ![info exists grades_wa($party_id)] } {
		set wrong_comments $comments_wa($party_id)
		ad_complain "[_ evaluation.lt_There_is_a_comment_fo]"
	    }
	    if { [info exists comments_wa($party_id)] && ([string length $comments_wa($party_id)] > 400) } {
		set wrong_comments $comments_wa($party_id)
		ad_complain "[_ evaluation.lt_There_is_a_comment_la_1]"
	    }
	}
	foreach party_id [array names comments_na] {
	    if { [info exists comments_na($party_id)] && ![info exists grades_na($party_id)] } {
		set wrong_comments $comments_na($party_id)
		ad_complain "[_ evaluation.lt_There_is_a_comment_fo]"
	    }
	    if { [info exists comments_na($party_id)] && ([string length $comments_na($party_id)] > 400) } {
		set wrong_comments $comments_na($party_id)
		ad_complain "[_ evaluation.lt_There_is_a_comment_la]"
	    }
	}
	foreach party_id [array names reasons] {
	    if { [info exists reasons($party_id)] && ![info exists grades($party_id)] } {
		set wrong_comments $reasons($party_id)
		ad_complain "[_ evaluation.lt_There_is_an_edit_reas]"
	    }
	    if { [info exists reasons($party_id)] && ([string length $reasons($party_id)] > 400) } {
		set wrong_comments $reasons($party_id)
		ad_complain "[_ evaluation.lt_There_is_an_edit_reas_1]"
	    }
	}
    }
}

set page_title "[_ evaluation.lt_Confirm_Your_Evaluati]"
set context [list [list "[export_vars -base student-list { task_id }]" "[_ evaluation.Studen_List_]"] "[_ evaluation.Confirm_Evaluation_]"]

db_1row get_task_info { *SQL* } 

# students with answer

# if the structure of the multirow datasource ever changes, this needs to be rewritten    
set counter 0
foreach party_id [array names show_student_wa] {
    if { [info exists grades_wa($party_id)] && $grades_wa($party_id) ne "" } { 
	incr counter 
	set party_name [db_string get_party_name { *SQL* }]
	set evaluations_wa:${counter}(rownum) $counter
	set evaluations_wa:${counter}(party_name) $party_name
	set evaluations_wa:${counter}(grade) $grades_wa($party_id)
	set evaluations_wa:${counter}(comment) " $comments_wa($party_id)"
	if {$show_student_wa($party_id) == "t"} {
	    set evaluations_wa:${counter}(show_student) "[_ evaluation.Yes_]"
	} else {
	    set evaluations_wa:${counter}(show_student) "[_ evaluation.No_]"
	}
	set item_ids($party_id) [db_nextval acs_object_id_seq]
    }
}

set evaluations_wa:rowcount $counter

# students with no answer

# if the structure of the multirow datasource ever changes, this needs to be rewritten    
set counter 0
foreach party_id [array names show_student_na] {
    if { [info exists grades_na($party_id)] && $grades_na($party_id) ne "" } { 
	incr counter 
	set party_name [db_string get_party_name { *SQL* }]
	set evaluations_na:${counter}(rownum) $counter
	set evaluations_na:${counter}(party_name) $party_name
	set evaluations_na:${counter}(grade) $grades_na($party_id)
	set evaluations_na:${counter}(comment) " $comments_na($party_id)"
	if {$show_student_na($party_id) == "t"} {
	    set evaluations_na:${counter}(show_student) "[_ evaluation.Yes_]"
	} else {
	    set evaluations_na:${counter}(show_student) "[_ evaluation.No_]"
	}
	set item_ids($party_id) [db_nextval acs_object_id_seq]
    }
}

set evaluations_na:rowcount $counter

# editing grades

# if the structure of the multirow datasource ever changes, this needs to be rewritten    
set counter 0
foreach party_id [array names show_student] {
    if { [info exists grades_to_edit($party_id)] && $grades_to_edit($party_id) ne "" } { 
	incr counter 
	set party_name [db_string get_party_name { *SQL* }]
	set evaluations:${counter}(rownum) $counter
	set evaluations:${counter}(party_name) $party_name
	set evaluations:${counter}(grade) $grades_to_edit($party_id)
	set evaluations:${counter}(reason) $reasons_to_edit($party_id)
	if {$show_student_to_edit($party_id) == "t"} {
	    set evaluations:${counter}(show_student) "[_ evaluation.Yes_]"
	} else {
	    set evaluations:${counter}(show_student) "[_ evaluation.No_]"
	}
    }
}

set evaluations:rowcount $counter

set export_vars [export_vars -form { grades_wa comments_wa show_student_wa grades_na comments_na show_student_na item_ids grades_to_edit reasons_to_edit show_student_to_edit item_to_edit_ids }]


template::add_event_listener -CSSclass "backbuttons" -script {history.go(-1);}




# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
