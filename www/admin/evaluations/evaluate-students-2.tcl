# /packages/evaluation/www/admin/evaluations/evaluate-students-2.tcl

ad_page_contract { 
	This page asks for an evaluation confirmation 

	@author jopez@galileo.edu 
	@creation-date Mar 2004
} { 
	task_id:integer,notnull
	grade_id:integer,notnull,optional
	max_grade:integer,notnull,optional
	item_ids:array,integer,optional
	item_to_edit_ids:array,optional

	grades_to_edit:array,optional
	reasons_to_edit:array,optional
	show_student_to_edit:array,optional

	grades_wa:array,optional
	comments_wa:array,optional
	show_student_wa:array,optional

	grades_na:array,optional
	comments_na:array,optional
	show_student_na:array,optional

	{return_url "student-list?[export_vars -url { task_id }]"}
} -validate {
	valid_grades_wa {
		set counter 0
		foreach party_id [array names grades_wa] {
			if { [info exists grades_wa($party_id)] && ![empty_string_p $grades_wa($party_id)] } {
				incr counter
				if { ![ad_var_type_check_number_p $grades_wa($party_id)] } {
					ad_complain "The grade most be a valid number ($grades_wa($party_id))"
				}
			}
		}
		if { !$counter && ([array size show_student_wa] > 0) } {
			ad_complain "There must be at least one grade to work with"
		}
	}
	valid_grades_na {
		set counter 0
		foreach party_id [array names grades_na] {
			if { [info exists grades_na($party_id)] && ![empty_string_p $grades_na($party_id)]} {
				incr counter
				if { ![ad_var_type_check_number_p $grades_na($party_id)] } {
					ad_complain "The grade most be a valid number ($grades_na($party_id))"
				}
			}
		}
		if { !$counter && ([array size show_student_na] > 0) } {
			ad_complain "There must be at least one grade to work with"
		}
	}
	valid_grades {
		set counter 0
		foreach party_id [array names grades_to_edit] {
			if { [info exists grades_to_edit($party_id)] && ![empty_string_p $grades_to_edit($party_id)] } {
				incr counter
				if { ![ad_var_type_check_number_p $grades_to_edit($party_id)] } {
					ad_complain "The grade most be a valid number ($grades_to_edit($party_id))"
				}
			}
		}
		if { !$counter && ([array size show_student_to_edit] > 0) } {
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
		foreach party_id [array names reasons_to_edit] {
			if { [info exists reasons_to_edit($party_id)] && ![info exists grades_to_edit($party_id)] } {
				ad_complain "There is an edit reason for a grade not realized ($reasons_to_edit($party_id))"
			}
			if { [info exists reasons_to_edit($party_id)] && ([string length $reasons_to_edit($party_id)] > 400) } {
				ad_complain "There is an edit reason larger than we can handle. ($reasons_to_edit($party_id))"
			}
		}
	}
}

db_transaction {
	foreach party_id [array names grades_wa] {
		if { ![info exists comments_wa($party_id)] } {
			set comments_wa($party_id) ""
		} else {
			set comments_wa($party_id) [DoubleApos $comments_wa($party_id)]
		}
		
		if { [info exists grades_wa($party_id)] && ![empty_string_p $grades_wa($party_id)] } {
			set grades_wa($party_id) [expr ($grades_wa($party_id)*100)/$max_grade.0]
			set revision_id [evaluation::new_evaluation -new_item_p 1 -item_id $item_ids($party_id) -content_type evaluation_student_evals \
								 -content_table evaluation_student_evals -content_id evaluation_id -description $comments_wa($party_id) \
								 -show_student_p $show_student_wa($party_id) -grade $grades_wa($party_id) -task_id $task_id -party_id $party_id]
			
			evaluation::set_live -revision_id $revision_id
		}
	}
}

db_transaction {
	foreach party_id [array names grades_na] {
		if { ![info exists comments_na($party_id)] } {
			set comments_na($party_id) ""
		} else {
			set comments_na($party_id) [DoubleApos $comments_na($party_id)]
		}
		if { [info exists grades_na($party_id)] && ![empty_string_p $grades_na($party_id)] } {
			set grades_na($party_id) [expr ($grades_na($party_id)*100)/$max_grade.0]
			set revision_id [evaluation::new_evaluation -new_item_p 1 -item_id $item_ids($party_id) -content_type evaluation_student_evals \
								 -content_table evaluation_student_evals -content_id evaluation_id -description $comments_na($party_id) \
								 -show_student_p $show_student_na($party_id) -grade $grades_na($party_id) -task_id $task_id -party_id $party_id]
			
			evaluation::set_live -revision_id $revision_id
		}
	}
}

db_transaction {
	foreach party_id [array names grades_to_edit] {
		if { [info exists grades_to_edit($party_id)] && ![empty_string_p $grades_to_edit($party_id)] } { 
			set grades_to_edit($party_id) [expr ($grades_to_edit($party_id)*100)/$max_grade.0]
			set revision_id [evaluation::new_evaluation -new_item_p 0 -item_id $item_to_edit_ids($party_id) -content_type evaluation_student_evals \
								 -content_table evaluation_student_evals -content_id evaluation_id -description $reasons_to_edit($party_id) \
								 -show_student_p $show_student_to_edit($party_id) -grade $grades_to_edit($party_id) -task_id $task_id -party_id $party_id]
			
			evaluation::set_live -revision_id $revision_id
		}
	}
}

ad_returnredirect "$return_url"

