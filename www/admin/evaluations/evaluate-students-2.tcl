# /packages/evaluation/www/admin/evaluations/evaluate-students-2.tcl

ad_page_contract { 
	This page asks for an evaluation confirmation 

	@author jopez@galileo.edu 
	@creation-date Mar 2004
	@cvs_id $Id$
} { 
	task_id:integer,notnull
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

	grades_gs:array,optional
	comments_gs:array,optional
	show_student_gs:array,optional
	new_p_gs:array,optional
	grades_sheet_item_id:integer,optional
	upload_file:optional
	{tmp_filename:optional ""}
	
} -validate {
	valid_grades_gs {
		set counter 0
		foreach party_id [array names grades_gs] {
			if { [info exists grades_gs($party_id)] && ![empty_string_p $grades_gs($party_id)] } {
				incr counter
				if { ![ad_var_type_check_number_p $grades_gs($party_id)] } {
					ad_complain "The grade most be a valid number ($grades_gs($party_id))"
				}
			}
		}
		if { !$counter && ([array size show_student_gs] > 0) } {
			ad_complain "There must be at least one grade to work with"
		}
	}
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
		foreach party_id [array names comments_gs] {
			if { [info exists comments_gs($party_id)] && ![info exists grades_gs($party_id)] } {
				ad_complain "There is a comment for a grade not realized ($comments_gs($party_id))"
			}
			if { [info exists comments_gs($party_id)] && ([string length $comments_gs($party_id)] > 400) } {
				ad_complain "There is a comment larger than we can handle. ($comments_gs($party_id))"
			}
		}
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

if { ![empty_string_p $tmp_filename] } {
	
	set tmp_filename "${tmp_filename}_grades_sheet"

	db_transaction {
		
		set title [template::util::file::get_property filename $upload_file]
		set mime_type [cr_filename_to_mime_type -create $title]

		set revision_id [evaluation::new_grades_sheet -new_item_p 1 -item_id $grades_sheet_item_id -content_type evaluation_grades_sheets \
							 -content_table evaluation_grades_sheets -content_id grades_sheet_id -storage_type lob -task_id $task_id \
							 -title $title -mime_type $mime_type]
		
		evaluation::set_live -revision_id $revision_id

		# create the new item
		db_dml lob_content " 		update cr_revisions	
			set lob = [set __lob_id [db_string get_lob_id "select empty_lob()"]]
			where revision_id = :revision_id
		" -blob_files [list $tmp_filename]
		
		set content_length [file size $tmp_filename]
		# Unfortunately, we can only calculate the file size after the lob is uploaded 
		db_dml lob_size { 	update cr_revisions
			set content_length = :content_length
			where revision_id = :revision_id
		}
		
		foreach party_id [array names grades_gs] {
			if { ![info exists comments_gs($party_id)] } {
				set comments_gs($party_id) ""
			} else {
				set comments_gs($party_id) [DoubleApos $comments_gs($party_id)]
			}
			
			if { [info exists grades_gs($party_id)] && ![empty_string_p $grades_gs($party_id)] } {
				set grades_gs($party_id) [expr ($grades_gs($party_id)*100)/$max_grade.0]
				set revision_id [evaluation::new_evaluation -new_item_p $new_p_gs($party_id) -item_id $item_ids($party_id) -content_type evaluation_student_evals \
									 -content_table evaluation_student_evals -content_id evaluation_id -description $comments_gs($party_id) \
									 -show_student_p $show_student_gs($party_id) -grade $grades_gs($party_id) -task_id $task_id -party_id $party_id]
				
				evaluation::set_live -revision_id $revision_id
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

ad_returnredirect "student-list?[export_vars { task_id } ]"

