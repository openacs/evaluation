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
		set grades_gs($party_id) [template::util::leadingTrim $grades_gs($party_id)]
		if { ![ad_var_type_check_number_p $grades_gs($party_id)] } {
		    set wrong_grade $grades_gs($party_id)
		    ad_complain "[_ evaluation.lt_The_grade_most_be_a_v]"
		}
	    }
	}
	if { !$counter && ([array size show_student_gs] > 0) } {
	    ad_complain "[_ evaluation.lt_There_must_be_at_leas]"
	}
    }
    valid_grades_wa {
	set counter 0
	foreach party_id [array names grades_wa] {
	    if { [info exists grades_wa($party_id)] && ![empty_string_p $grades_wa($party_id)] } {
		incr counter
		set grades_wa($party_id) [template::util::leadingTrim $grades_wa($party_id)]
		if { ![ad_var_type_check_number_p $grades_wa($party_id)] } {
		    set wrong_grade $grades_wa($party_id)
		    ad_complain "[_ evaluation.lt_The_grade_most_be_a_v]"
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
	    if { [info exists grades_na($party_id)] && ![empty_string_p $grades_na($party_id)]} {
		incr counter
		set grades_na($party_id) [template::util::leadingTrim $grades_na($party_id)]
		if { ![ad_var_type_check_number_p $grades_na($party_id)] } {
		    set wrong_grade $grades_na($party_id)
		    ad_complain "[_ evaluation.lt_The_grade_most_be_a_v]"
		}
	    }
	}
	if { !$counter && ([array size show_student_na] > 0) } {
	    ad_complain "[_ evaluation.lt_There_must_be_at_leas]"
	}
    }
    valid_grades {
	set counter 0
	foreach party_id [array names grades_to_edit] {
	    if { [info exists grades_to_edit($party_id)] && ![empty_string_p $grades_to_edit($party_id)] } {
		incr counter
		set grades_to_edit($party_id) [template::util::leadingTrim $grades_to_edit($party_id)]
		if { ![ad_var_type_check_number_p $grades_to_edit($party_id)] } {
		    set wrong_grade $grades_to_edit($party_id)
		    ad_complain "[_ evaluation.lt_The_grade_most_be_a_v]"
		}
	    }
	}
	if { !$counter && ([array size show_student_to_edit] > 0) } {
	    ad_complain "[_ evaluation.lt_There_must_be_at_leas]"
	}
    }
    valid_data {
	foreach party_id [array names comments_gs] {
	    if { [info exists comments_gs($party_id)] && ![info exists grades_gs($party_id)] } {
		set wrong_comments $comments_gs($party_id)
		ad_complain "[_ evaluation.lt_There_is_a_comment_fo]"
	    }
	    if { [info exists comments_gs($party_id)] && ([string length $comments_gs($party_id)] > 400) } {
		set wrong_comments $comments_gs($party_id)
		ad_complain "[_ evaluation.lt_There_is_a_comment_la]"
	    }
	}
	foreach party_id [array names comments_wa] {
	    if { [info exists comments_wa($party_id)] && ![info exists grades_wa($party_id)] } {
		set wrong_comments $comments_wa($party_id)
		ad_complain "[_ evaluation.lt_There_is_a_comment_fo]"
	    }
	    if { [info exists comments_wa($party_id)] && ([string length $comments_wa($party_id)] > 400) } {
		set wrong_comments $comments_wa($party_id)
		ad_complain "[_ evaluation.lt_There_is_a_comment_la]"
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
	foreach party_id [array names reasons_to_edit] {
	    if { [info exists reasons_to_edit($party_id)] && ![info exists grades_to_edit($party_id)] } {
		set wrong_comments $reasons_to_edit($party_id)
		ad_complain "[_ evaluation.lt_There_is_an_edit_reas]"
	    }
	    if { [info exists reasons_to_edit($party_id)] && ([string length $reasons_to_edit($party_id)] > 400) } {
		set wrong_comments $reasons_to_edit($party_id)
		ad_complain "[_ evaluation.lt_There_is_an_edit_reas_1]"
	    }
	}
    }
}

db_1row task_info { *SQL* }

if { ![empty_string_p $tmp_filename] } {

    set tmp_filename "${tmp_filename}_grades_sheet"

    db_transaction {
	
	set title [template::util::file::get_property filename $upload_file]
	set mime_type [cr_filename_to_mime_type -create $title]

	if { [parameter::get -parameter "StoreFilesInDatabaseP" -package_id [ad_conn package_id]] } {
	    set storage_type file
	} else {
	    set storage_type lob
	}
	set revision_id [evaluation::new_grades_sheet -new_item_p 1 -item_id $grades_sheet_item_id -content_type evaluation_grades_sheets \
			     -content_table evaluation_grades_sheets -content_id grades_sheet_id -storage_type $storage_type -task_item_id $task_item_id \
			     -title $title -mime_type $mime_type]
	
	content::item::set_live_revision -revision_id $revision_id
        set content_length [file size $tmp_filename]
	if { [parameter::get -parameter "StoreFilesInDatabaseP" -package_id [ad_conn package_id]] } {
	    # create the new item
	    
	    set file_name [cr_create_content_file $grades_sheet_item_id $revision_id $tmp_filename]
	    db_dml set_file_content { *SQL* }
	    
	} else {

	    # create the new item
	    db_dml lob_content { *SQL* } -blob_files [list $tmp_filename]
	    
	
	    # Unfortunately, we can only calculate the file size after the lob is uploaded 
	    db_dml lob_size { *SQL* }
	}
	
	foreach party_id [array names grades_gs] {
	    if { ![info exists comments_gs($party_id)] } {
		set comments_gs($party_id) ""
	    } else {
		set comments_gs($party_id) [DoubleApos $comments_gs($party_id)]
	    }
	    
	    if { [info exists grades_gs($party_id)] && ![empty_string_p $grades_gs($party_id)] } {
		set grades_gs($party_id) [expr ($grades_gs($party_id)*100)/$max_grade.0]
		set revision_id [evaluation::new_evaluation -new_item_p $new_p_gs($party_id) \
							 -item_id $item_ids($party_id) \
							 -content_type evaluation_student_evals \
							 -content_table evaluation_student_evals \
							 -content_id evaluation_id \
							 -description $comments_gs($party_id) \
							 -show_student_p $show_student_gs($party_id) \
							 -grade $grades_gs($party_id) \
							 -task_item_id $task_item_id \
							 -party_id $party_id]
		
		content::item::set_live_revision -revision_id $revision_id
		
		if { [string eq $new_p_gs($party_id) 0] } {
		    # if editing the grade, send the notification
		    evaluation::notification::do_notification -task_id $task_id -evaluation_id $revision_id -package_id [ad_conn package_id] -notif_type one_evaluation_notif
		}
		
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
	    # new file?
	    if { [db_string grades_wa_new { *SQL* }] } {
		set new_item_p 0
	    } else {
		set new_item_p 1
	    }
	    set grades_wa($party_id) [expr ($grades_wa($party_id)*100)/$max_grade.0]
	    set revision_id [evaluation::new_evaluation -new_item_p $new_item_p -item_id $item_ids($party_id) -content_type evaluation_student_evals \
				 -content_table evaluation_student_evals -content_id evaluation_id -description $comments_wa($party_id) \
				 -show_student_p $show_student_wa($party_id) -grade $grades_wa($party_id) -task_item_id $task_item_id -party_id $party_id]
	    
	    content::item::set_live_revision -revision_id $revision_id
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
	    # new file?
	    if { [db_string grades_na_new { *SQL* }] } {
		set new_item_p 0
	    } else {
		set new_item_p 1
	    }
	    set grades_na($party_id) [expr ($grades_na($party_id)*100)/$max_grade.0]
	    set revision_id [evaluation::new_evaluation -new_item_p $new_item_p -item_id $item_ids($party_id) -content_type evaluation_student_evals \
				 -content_table evaluation_student_evals -content_id evaluation_id -description $comments_na($party_id) \
				 -show_student_p $show_student_na($party_id) -grade $grades_na($party_id) -task_item_id $task_item_id -party_id $party_id]
	    
	    content::item::set_live_revision -revision_id $revision_id
	}
    }
}

db_transaction {
    foreach party_id [array names grades_to_edit] {
	if { [info exists grades_to_edit($party_id)] && ![empty_string_p $grades_to_edit($party_id)] } { 
	    set grades_to_edit($party_id) [expr ($grades_to_edit($party_id)*100)/$max_grade.0]
	    set revision_id [evaluation::new_evaluation -new_item_p 0 -item_id $item_to_edit_ids($party_id) -content_type evaluation_student_evals \
				 -content_table evaluation_student_evals -content_id evaluation_id -description $reasons_to_edit($party_id) \
				 -show_student_p $show_student_to_edit($party_id) -grade $grades_to_edit($party_id) -task_item_id $task_item_id -party_id $party_id]
	    
	    content::item::set_live_revision -revision_id $revision_id

	    # send the notification to everyone suscribed
	    evaluation::notification::do_notification -task_id $task_id -evaluation_id $revision_id -package_id [ad_conn package_id] -notif_type one_evaluation_notif

	}
    }
}

ad_returnredirect "student-list?[export_vars { task_id } ]"

