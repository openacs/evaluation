# /packages/evaluation/www/admin/evaluations/grades-sheet-parse.tcl 

ad_page_contract { 
    
    Parse the csv file with the grades or the parties for a given task
    
    @author jopez@galileo.edu
    @creation_date May 2004
    @cvs_id $Id$
} { 
    upload_file:notnull 
    upload_file.tmpfile:notnull
    task_id:integer,notnull
    grades_sheet_item_id:integer,notnull
} -validate { 
    csv_type_p {
	set file_extension [file extension $upload_file]
	if { [string compare [string tolower $file_extension] ".csv"] } { 
	    ad_complain "[_ evaluation.lt_The_file_extension_of_1]"
        } 
    } 
}  

set page_title "[_ evaluation.Confirm_Evaluation_]"

set context [list [list "[export_vars -base student-list { task_id }]" "[_ evaluation.Studen_List_]"] "[_ evaluation.Confirm_Evaluation_]"]

# Getting some info from the db about the task
if ![db_0or1row get_task_info { *SQL* }] { 
    # This should never happen. 
    ad_return_complaint 1 "<li>[_ evaluation.lt_There_is_no_informati]</li>" 
    return 
} 

set evaluations_gs:rowcount 0

# Double-click protection 
if { ![db_string file_exists { *SQL* }] } { 
    
    set max_n_bytes [parameter::get -parameter MaxNumberOfBytes]
    
    set tmp_filename [ns_queryget upload_file.tmpfile] 
    
    if { ![empty_string_p $max_n_bytes] && ([file size "$tmp_filename"] > $max_n_bytes) } { 
	set pretty_maxnbytes [lc_numeric $max_n_bytes]
	ad_return_complaint 1 "[_ evaluation.lt_The_file_is_too_large_1]"
	return 0 
    } 

    set errors 0 
    set errors_text "" 
    set counter 0 

    set line_number 0 
    
    set file_handler [open $tmp_filename {RDWR}] 
    
    while { ![eof $file_handler] } { 
	incr line_number 
	set one_line [gets $file_handler] 
	
	# jump first two lines 
	if { $line_number <= 2 } { 
	    continue 
	} 
	
	# replace enters (<-|) with semicolons (;)
	regsub -all {(,[\r\n])} $one_line "" clean_line 
	regsub -all {[\r\n]} $clean_line "" clean_line 
	
	set evaluation [split $clean_line ","] 
	
	if { $line_number == 3 } {
	    set max_grade [string trim [lindex $evaluation 1]] 
	    if { ![ad_var_type_check_number_p $max_grade] } {
		ad_return_error "Invalid Max Grade" "Max Grade does not seem to be a real number. Please don't leave it blank."
		return 
	    }
	    continue
	} elseif { $line_number == 4 } {
	    set see_comments_p [string trim [string tolower [lindex $evaluation 1]]] 			
	    # removing the first and last " that comes from the csv format
	    regsub  ^\" $see_comments_p "" see_comments_p
	    regsub  \"\$ $see_comments_p "" see_comments_p
	    if { ![string eq $see_comments_p 1] && ![string eq $see_comments_p 0] } {
		ad_return_error "[_ evaluation.Bad_input_]" "[_ evaluation.lt_Input_Will_the_studen]"
		return 
	    } elseif { [string eq $see_comments_p 1] } {
		set comments_p "t"
	    } else {
		set comments_p "f"
	    }
	    continue
	} elseif { $line_number <= 6 } {
	    continue
	}
	
	set party_id [string trim [lindex $evaluation 0]] 
	set party_name [db_string get_party_name { *SQL* }]
	set grade [string trim [lindex $evaluation 2]] 
	set comments [string trim [lindex $evaluation 3]]
	
	# removing the first and last " that comes from the csv format
	regsub  ^\" $comments "" comments
	regsub  \"\$ $comments "" comments
	
	if { [empty_string_p $party_id] && [empty_string_p $grade] && [empty_string_p $comments] } { 
	    # "blank" line, skip it
	    continue 
	} 
	
	if { ![empty_string_p $grade] } { 
	    # start validations
	    if { ![ad_var_type_check_integer_p $party_id] } { 
		incr errors 
		append errors_text "<li> [_ evaluation.lt_Party_id_party_id_doe]</li>" 
	    } 
	    
	    if { ![ad_var_type_check_number_p $grade] } { 
		incr errors 
		append errors_text "<li> [_ evaluation.lt_Grade_grade_does_not_]</li>" 
	    } 
	    
	    if { [string length $comments] > 4000 } { 
		incr errors 
		append errors_text "<li> [_ evaluation.lt_Commentedit_reason_on]</li>" 
	    } 

	    # editing without reason
	    if { ![string eq [format %.2f [db_string check_evaluated { *SQL* } -default $grade]] [format %.2f $grade]] && [empty_string_p $comments] } { 
		incr errors
		append errors_text "<li> [_ evaluation.lt_There_must_be_an_edit]</li>"
	    } 
	    
	    if { $errors } { 
		ad_return_complaint $errors $errors_text 
		ad_script_abort
		return 
	    } 
	    
	    if { ![empty_string_p $comments] } {
		if { [db_string verify_grade_change { *SQL* } -default 0] } { 
		    # there is no change, skip it
		    continue 
		} 
	    } else {
		if { [db_string verify_grade_change_wcomments { *SQL* } -default 0] } { 
		    # there is no change, skip it
		    continue 
		} 
	    }
	    
	    # validation checked, prepare data structures for next page
	    incr counter 

	    set grades_gs($party_id) $grade
	    set comments_gs($party_id) $comments
	    set show_student_gs($party_id) $comments_p

	    set evaluations_gs:${counter}(rownum) $counter
	    set evaluations_gs:${counter}(party_name) $party_name
	    set evaluations_gs:${counter}(grade) $grade
	    set evaluations_gs:${counter}(comment) $comments
	    if { [string eq $comments_p "t"] } {
		set evaluations_gs:${counter}(show_student) "[_ evaluation.Yes_]"
	    } else {
		set evaluations_gs:${counter}(show_student) "[_ evaluation.No_]"
	    }

	    set evaluation_id [db_string editing_p { *SQL* } -default 0]
	    if { $evaluation_id } {
		set item_ids($party_id) [db_string get_item_id { *SQL* }]
		set new_p_gs($party_id) 0
	    } else {
		set item_ids($party_id) [db_nextval acs_object_id_seq]
		set new_p_gs($party_id) 1
	    }

	}
    }
    set evaluations_gs:rowcount $counter
    set export_vars [export_vars -form { task_id max_grade grades_gs comments_gs show_student_gs item_ids new_p_gs grades_sheet_item_id tmp_filename upload_file }]

    # writing the file in the file system so we can work with it later
    flush $file_handler
    close $file_handler

    if [catch {exec mv $tmp_filename "${tmp_filename}_grades_sheet"} errmsg] { 
	ad_return_error "[_ evaluation.lt_Error_while_storing_f]" "[_ evaluation.lt_There_was_a_problem_s]" 
	ad_script_abort
    } 
}
