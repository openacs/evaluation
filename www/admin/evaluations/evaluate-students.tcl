# /packages/evaluation/www/admin/evaluations/evaluate-students.tcl

ad_page_contract { 
	This page asks for an evaluation confirmation 

	@author jopez@galileo.edu 
	@creation-date Mar 2004
} { 
	task_id:integer,notnull
	grade_id:integer,notnull
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
			if { [info exists grades_wa($party_id)] && ![empty_string_p $grades_wa($party_id)] } {
				incr counter
				if { ![ad_var_type_check_number_p $grades_wa($party_id)] } {
					ad_complain "The grade must be a valid number ($grades_wa($party_id))"
				}
			}
		}
		if { !$counter && ([array size show_student_wa] > 0)} {
			ad_complain "There must be at least one grade to work with"
		}
	}
	valid_grades_na {
		set counter 0
		foreach party_id [array names grades_na] {
			if { [empty_string_p $grade_all] } {
				if { [info exists grades_na($party_id)] && ![empty_string_p $grades_na($party_id)] } {
					incr counter
					if { ![ad_var_type_check_number_p $grades_na($party_id)] } {
						ad_complain "The grade must be a valid number ($grades_na($party_id))"
					}
				}
			} else {
				set grades_na($party_id) 0
			}
		}
		if { !$counter && ([array size show_student_na] > 0) && [empty_string_p $grade_all] } {
			ad_complain "There must be at least one grade to work with"
		}
	}
	valid_grades {
		set counter 0
		foreach party_id [array names grades] {
			if { [info exists grades($party_id)] && ![empty_string_p $grades($party_id)] } {
				if { ![ad_var_type_check_number_p $grades($party_id)] } {
					ad_complain "The grade most be a valid number ($grades($party_id))"
				} else {			
					set old_grade  [format %.2f [db_string get_old_grade { *SQL* }]]
					if { ![string eq $old_grade  [format %.2f $grades($party_id)]] } {
						incr counter
						if { ![info exists reasons($party_id)] || [empty_string_p $reasons($party_id)] } {
							ad_complain "You must give an edit reason ($old_grade --> $grades($party_id))"
						}
						set grades_to_edit($party_id) $grades($party_id)
						set reasons_to_edit($party_id) $reasons($party_id)
						set show_student_to_edit($party_id) $show_student($party_id)				
					}
				}
			}
		}
		if { !$counter && ([array size show_student] > 0) } {
			ad_complain "There must be at least one grade to work with"
		}
	}
	valid_data {
		foreach party_id [array names comments_wa] {
			if { [info exists comments_wa($party_id)] && ![info exists grades_wa($party_id)] } {
				ad_complain "There is a comment for a grade not realized ($comments_wa($party_id))"
			}
			if { [info exists comments_wa($party_id)] && ([string length $comments_wa($party_id)] > 400) } {
				ad_complain "There is a comment larger than we can handle. ($comments_wa($party_id))"
			}
		}
		foreach party_id [array names comments_na] {
			if { [info exists comments_na($party_id)] && ![info exists grades_na($party_id)] } {
				ad_complain "There is a comment for a grade not realized ($comments_na($party_id))"
			}
			if { [info exists comments_na($party_id)] && ([string length $comments_na($party_id)] > 400) } {
				ad_complain "There is a comment larger than we can handle. ($comments_na($party_id))"
			}
		}
		foreach party_id [array names reasons] {
			if { [info exists reasons($party_id)] && ![info exists grades($party_id)] } {
				ad_complain "There is an edit reason for a grade not realized ($reasons($party_id))"
			}
			if { [info exists reasons($party_id)] && ([string length $reasons($party_id)] > 400) } {
				ad_complain "There is an edit reason larger than we can handle. ($reasons($party_id))"
			}
		}
	}
}

set page_title "Confirm Your Evaluation"
set context [list [list "[export_vars -base student-list { task_id }]" "Studen List"] "Confirm Evaluation"]

db_1row get_task_info { *SQL* } 

# students with answer

# if the structure of the multirow datasource ever changes, this needs to be rewritten    
set counter 0
foreach party_id [array names show_student_wa] {
	if { [info exists grades_wa($party_id)] && ![empty_string_p $grades_wa($party_id)] } { 
		incr counter 
		set party_name [db_string get_party_name { *SQL }]
		set evaluations_wa:${counter}(rownum) $counter
		set evaluations_wa:${counter}(party_name) $party_name
		set evaluations_wa:${counter}(grade) $grades_wa($party_id)
		set evaluations_wa:${counter}(comment) $comments_wa($party_id)
		if { [string eq $show_student_wa($party_id) "t"] } {
			set evaluations_wa:${counter}(show_student) Yes
		} else {
			set evaluations_wa:${counter}(show_student) No
		}
		set item_ids($party_id) [db_nextval acs_object_id_seq]
	}
}

set evaluations_wa:rowcount $counter

# students with no answer

# if the structure of the multirow datasource ever changes, this needs to be rewritten    
set counter 0
foreach party_id [array names show_student_na] {
	if { [info exists grades_na($party_id)] && ![empty_string_p $grades_na($party_id)] } { 
		incr counter 
		set party_name [db_string get_party_name { *SQL* }]
		set evaluations_na:${counter}(rownum) $counter
		set evaluations_na:${counter}(party_name) $party_name
		set evaluations_na:${counter}(grade) $grades_na($party_id)
		set evaluations_na:${counter}(comment) $comments_na($party_id)
		if { [string eq $show_student_na($party_id) "t"] } {
			set evaluations_na:${counter}(show_student) Yes
		} else {
			set evaluations_na:${counter}(show_student) No
		}
		set item_ids($party_id) [db_nextval acs_object_id_seq]
	}
}

set evaluations_na:rowcount $counter

# editting grades

# if the structure of the multirow datasource ever changes, this needs to be rewritten    
set counter 0
foreach party_id [array names show_student] {
	if { [info exists grades_to_edit($party_id)] && ![empty_string_p $grades_to_edit($party_id)] } { 
		incr counter 
		set party_name [db_string get_party_name { *SQL* }]
		set evaluations:${counter}(rownum) $counter
		set evaluations:${counter}(party_name) $party_name
		set evaluations:${counter}(grade) $grades_to_edit($party_id)
		set evaluations:${counter}(reason) $reasons_to_edit($party_id)
		if { [string eq  $show_student_to_edit($party_id) "t"] } {
			set evaluations:${counter}(show_student) Yes
		} else {
			set evaluations:${counter}(show_student) No
		}
	}
}

set evaluations:rowcount $counter

set export_vars [export_vars -form { grades_wa comments_wa show_student_wa grades_na comments_na show_student_na item_ids grades_to_edit reasons_to_edit show_student_to_edit item_to_edit_ids }]




