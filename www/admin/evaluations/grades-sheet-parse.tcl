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
        if { [string compare [string tolower [file extension $upload_file]] ".csv"] } { 
            ad_complain "The file extension of the file is "[file extension $upload_file]" and it should be .CSV, we can't process it"
        } 
    } 
}  

set page_title "Confirm Evaluation"
set context [list [list "[export_vars -base student-list { task_id }]" "Studen List"] "Confirm Evaluation"]

# Getting some info from the db about the task
if ![db_0or1row get_task_info { *SQL* }] { 
				# This should never happen. 
				ad_return_complaint 1 "<li>There is no information about this task.</li>" 
				return 
			} 

set evaluations_gs:rowcount 0

# Double-click protection 
if { ![db_string file_exists { *SQL* }] } { 
	
	set max_n_bytes [parameter::get -parameter MaxNumberOfBytes]

	set tmp_filename [ns_queryget upload_file.tmpfile] 
	
    if { ![empty_string_p $max_n_bytes] && ([file size "$tmp_filename"] > $max_n_bytes) } { 
        ad_return_complaint 1 "The file is too large. (The maximun file size is [util_commify_number $max_n_bytes] bytes)" 
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
			if { ![string eq $see_comments_p yes] && ![string eq $see_comments_p no] } {
				ad_return_error "Bad input" "Input \"Will the student be able to see the grade\" must be YES or NO, please don't leave it blank."
				return 
			} elseif { [string eq $see_comments_p \"yes\"] } {
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
				append errors_text "<li> Party_id $party_id does not seems to be an integer. Please don't modify this field.</li>" 
			} 
			
			if { ![ad_var_type_check_number_p $grade] } { 
				incr errors 
				append errors_text "<li> Grade $grade does not seem to be a real number.</li>" 
			} 
			
			if { [string length $comments] > 4000 } { 
				incr errors 
				append errors_text "<li> Comment/edit reason on party_id $party_id is larger than 4,000 characters long, which is our max lenght. Please make this comment/edit reason shorter.</li>" 
			} 

			# editing without reason
			if { ![string eq [format %.2f [db_string check_evaluated { *SQL* } -default $grade]] [format %.2f $grade]] && [empty_string_p $comments] } { 
				incr errors
			    append errors_text "<li> (ahora $grade, antes [db_string check_evaluated { *SQL* } -default $grade] There must be an edit reason if you want to edit the grade on party_id ${party_id}.</li>"
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
				set evaluations_gs:${counter}(show_student) Yes
			} else {
				set evaluations_gs:${counter}(show_student) No
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
        ad_return_error "Error while storing file" "There was a problem storing the file. Please contact the administrator.   
        <p>This was the error: <pre>$errmsg</pre></li>" 
		ad_script_abort
    } 
}

