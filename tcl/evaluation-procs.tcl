ad_library {
    Procedures in the evaluation namespace.
    
    @creation-date Feb 2004
    @author jopez@galileo.edu
    @cvs-id $Id$
}

namespace eval evaluation {}

#####
#
#  evaluation namespace
#
#####


ad_proc -public evaluation::package_key {} {
    return "evaluation"
}

ad_proc -public evaluation::make_url { 
	-file_name_from_db:required 
} {
    if { [regexp "view" $file_name_from_db] } {
		return $file_name_from_db
	} elseif { [regexp "http://" $file_name_from_db] } {
		return $file_name_from_db
	} else {
		return $file_name_from_db
	}
}


ad_proc -public evaluation::new_grade {
	-item_id:required
	-content_type:required
	-content_table:required
	-content_id:required
	-new_item_p:required
	-description:required
	-weight:required
	-name:required
} {

	Build a new content revision of a evaluation subtype.  If new_item_p is
	set true then a new item is first created, otherwise a new revision is created for
	the item indicated by item_id.

	@param item_id The item to update or create.
	@param content_type The type to make
	@param content_table
	@param new_item_p If true make a new item using item_id

} {

	set package_id [ad_conn package_id]
	set creation_user [ad_verify_and_get_user_id]
	set creation_ip [ad_conn peeraddr]

	set item_name "${content_type}_${item_id}"

	set revision_id [db_nextval acs_object_id_seq]
	set revision_name "${content_type}_${revision_id}"

	if { $new_item_p } {
		db_exec_plsql content_item_new { *SQL* }
		
	}
	
	db_exec_plsql content_revision_new { *SQL* }
	
	return $revision_id
} 


ad_proc -public evaluation::set_live {
	-revision_id:required
} {

	Makes a live revision of the revision_id provided.

	@param revision_id The revision to set live.
} {
	db_exec_plsql content_set_live_revision { *SQL* }
	return 
}



ad_proc -private evaluation::export_entire_form_except { args } { 
	Exports all but part of a form 
} { 
    # exports entire form except the variables specified in args 
    set hidden "" 
    set the_form [ns_getform] 
    if {![empty_string_p $the_form]} { 
        for {set i 0} {$i<[ns_set size $the_form]} {incr i} { 
            set varname [ns_set key $the_form $i] 
            if { [lsearch -exact $args $varname] == -1 } { 
                set varvalue [ns_set value $the_form $i] 
                append hidden "<input type=hidden name=\"$varname\" value=\"[ad_quotehtml $va\
rvalue]\">\n" 
            } 
        } 
    } 
    return $hidden 
} 


ad_proc -private evaluation::now_plus_days { -ndays } {
    Create a new Date object for the current date and time 
    plus the number of days given
    with the default interval for minutes

    @author jopez@galileo.edu
    @creation-date Mar 2004
} {
	set now [list]
	foreach v [clock format [clock seconds] -format "%Y %m %d %H %M %S"] {
		lappend now [template::util::leadingTrim $v]
	}

	set day [lindex $now 2]
	set month [lindex $now 1]
	set interval_def [template::util::date::defaultInterval day]
	for { set i [lindex $interval_def 0] }  { $i <= 15 }  { incr i 1 } {
		incr day
		if { [expr $day + $i] >= [lindex $interval_def 1] } {
			incr month 1
			set day 1
		}
	}
    
	# replace the hour and minute values in the now list with new values
	set now [lreplace $now 2 2 $day]
	set now [lreplace $now 1 1 $month]

	return [eval template::util::date::create $now]
}

ad_proc -public evaluation::new_task {
	-item_id:required
	-content_type:required
	-content_table:required
	-content_id:required
	-new_item_p:required
	-name:required
	-grade_id:required
	-number_of_members:required
	-requires_grade_p:required
	-storage_type:required
	{-online_p ""}
	{-due_date ""}
	{-weight:required ""}
	{-late_submit_p ""}
	{-description ""}
	{-title ""}
	{-mime_type "text/plain"}
	{-item_name ""}
} {

	Build a new content revision of a task.  If new_item_p is
	set true then a new item is first created, otherwise a new revision is created for
	the item indicated by item_id.

	@param item_id The item to update or create.
	@param content_type The type to make
	@param content_table
	@param new_item_p If true make a new item using item_id
	@param grade_id Grade type where the task belongs
	@param name The name of the task
	@number_of_members If the task is in groups this parameter must be > 1
	@param online_p If the task will be submited online
	@due_date Due date of the task
	@weight Weight of the task in the grade type
	@late_submit_p If the students will be able to submit the task after due date
	@description Description of the task
	@storage_type File or text, depending on what are we going to store

} {

	set package_id [ad_conn package_id]
	set creation_user [ad_verify_and_get_user_id]
	set creation_ip [ad_conn peeraddr]

	if { [empty_string_p $item_name] } {
		set item_name "${item_id}_${title}"
	}

	set revision_id [db_nextval acs_object_id_seq]

	if { $new_item_p } {
		db_exec_plsql content_item_new { *SQL* }
		
	}
	
	db_exec_plsql content_revision_new { *SQL* }

	# in order to find the file we have to set the name in cr_items the same that in cr_revisions
	db_dml update_item_name { *SQL* }
	return $revision_id
} 


ad_proc -public evaluation::new_solution {
	-item_id:required
	-content_type:required
	-content_table:required
	-content_id:required
	-new_item_p:required
	-task_id:required
	-storage_type:required
	-title:required
	{-mime_type "text/plain"}
} {

	Build a new content revision of a task solution.  If new_item_p is
	set true then a new item is first created, otherwise a new revision is created for
	the item indicated by item_id.

	@param item_id The item to update or create.
	@param content_type The type to make
	@param content_table
	@param new_item_p If true make a new item using item_id
	@param task_id Task which "owns" the solution
	@param title The name of the task solution
	@param storage_type lob or text, depending on what are we going to store

} {

	set package_id [ad_conn package_id]
	set creation_user [ad_verify_and_get_user_id]
	set creation_ip [ad_conn peeraddr]

	set item_name "${item_id}_${title}"

	set revision_id [db_nextval acs_object_id_seq]

	if { $new_item_p } {
		db_exec_plsql content_item_new { *SQL* }
	}
	
	db_exec_plsql content_revision_new { *SQL* }

	# in order to find the file we have to set the name in cr_items the same that in cr_revisions
	db_dml update_item_name { *SQL* }
	return $revision_id
} 


ad_proc -public evaluation::new_answer {
	-item_id:required
	-content_type:required
	-content_table:required
	-content_id:required
	-new_item_p:required
	-task_id:required
	-storage_type:required
	-title:required
	-party_id:required
	{-mime_type "text/plain"}
} {

	Build a new content revision of an answer.  If new_item_p is
	set true then a new item is first created, otherwise a new revision is created for
	the item indicated by item_id.

	@param item_id The item to update or create.
	@param content_type The type to make
	@param content_table
	@param new_item_p If true make a new item using item_id
	@param task_id Task which "owns" the answer
	@param title The name of the task solution
	@param storage_type lob or text, depending on what are we going to store
	@param party_id Group or user_id thaw owns the anser
} {

	set package_id [ad_conn package_id]
	set creation_user [ad_verify_and_get_user_id]
	set creation_ip [ad_conn peeraddr]

	set item_name "${item_id}_${title}"

	set revision_id [db_nextval acs_object_id_seq]

	if { $new_item_p } {
		db_exec_plsql content_item_new { *SQL* }
	}
	
	db_exec_plsql content_revision_new { *SQL* }

	# in order to find the file we have to set the name in cr_items the same that in cr_revisions
	db_dml update_item_name { *SQL* }
	return $revision_id
} 

ad_proc -public evaluation::new_evaluation {
	-item_id:required
	-content_type:required
	-content_table:required
	-content_id:required
	-new_item_p:required
	-party_id:required
	-task_id:required
	-grade:required
	{-title "evaluation"}
	{-show_student_p "t"}
	{-storage_type "text"}
	{-description ""}
	{-mime_type "text/plain"}
} {
	
	Build a new content revision of an evaluation.  If new_item_p is
	set true then a new item is first created, otherwise a new revision is created for
	the item indicated by item_id.

	@param item_id The item to update or create.
	@param content_type The type to make
	@param content_table
	@param new_item_p If true make a new item using item_id
	@param task_id Task been evaluated
	@param party_id Party been evaluated
	@param grade Grade of the evaluation
	@param show_student_p If the student(s) will be able to see the grade
	@param storage_type lob or text, depending on what are we going to store
	@param description Comments on the evaluation
	@param mime_type Mime type of the evaluation.
} {

	set package_id [ad_conn package_id]
	set creation_user [ad_verify_and_get_user_id]
	set creation_ip [ad_conn peeraddr]

	set item_name "${item_id}_${title}"

	set revision_id [db_nextval acs_object_id_seq]

	if { $new_item_p } {
		db_exec_plsql content_item_new { *SQL* }
	}
	
	db_exec_plsql content_revision_new { *SQL* }

} 

ad_proc -public evaluation::new_evaluation_group {
	-group_id:required
	-group_name:required
	-task_id:required
	{-context ""}
} {

	Build a new group of type evlaution_groups for the tasks.
	This procedure is just a wrapper for the pl/sql function evaluation.new_evalatuion_group
	which uses the acs_group.new funcion.

	@param group_id The group_id that will be created.
	@param group_key Key for the group.
	@param pretty_name 
	@param task_id The task that will be done by the group.
	@param context_id If not provided, it will be the package_id.

} {

	if { [empty_string_p $context] } {
		set context [ad_conn package_id]
	}
	set creation_user [ad_verify_and_get_user_id]
	set creation_ip [ad_conn peeraddr]

	db_exec_plsql evaluation_group_new { *SQL* }
	
	return $group_id
} 

ad_proc -public evaluation::evaluation_group_name {
	-group_id:required
} {

	@param group_id

} {

	return [db_exec_plsql evaluation_group_name { *SQL* }]

} 

ad_proc -public evaluation::new_grades_sheet {
	-item_id:required
	-content_type:required
	-content_table:required
	-content_id:required
	-new_item_p:required
	-task_id:required
	-storage_type:required
	-title:required
	-mime_type:required
} {

	Build a new content revision of a grades sheet.  If new_item_p is
	set true then a new item is first created, otherwise a new revision is created for
	the item indicated by item_id.

	@param item_id The item to update or create.
	@param content_type The type to make
	@param content_table
	@param new_item_p If true make a new item using item_id
	@param task_id Task which "owns" the grades sheet
	@param title The name of the grades sheet
	@param storage_type lob 
	@param mime_type Mime tipe of the grades sheet

} {

	set package_id [ad_conn package_id]
	set creation_user [ad_verify_and_get_user_id]
	set creation_ip [ad_conn peeraddr]

	set item_name "${item_id}_${title}"

	set revision_id [db_nextval acs_object_id_seq]

	if { $new_item_p } {
		db_exec_plsql content_item_new { *SQL* }
	}
	
	db_exec_plsql content_revision_new { *SQL* }

	return $revision_id
} 

ad_proc -public evaluation::generate_grades_sheet {} {

    # Get file_path from url 
    set url [ns_conn url] 
	
    regexp {/grades-sheet-csv-([^.]+).csv$} $url match task_id  
	
    if { ![db_0or1row get_task_info "select et.task_name, et.number_of_members
                                 from evaluation_tasks et
                                 where et.task_id = :task_id"] } { 
		# this should never happen
        ad_return_error "No information" "There has been an error, there is no infomraiton about the task $task_id"
        return 
    } 
	
    set csv_content [list] 
    lappend csv_content "Grades sheet for assighment \"$task_name\""  

	lappend csv_content "\nMax Grade:"
  	lappend csv_content "100"
	lappend csv_content "\nWill the student be able to see the grade? (Yes/No):"
  	lappend csv_content "Yes"

	lappend csv_content "\n\nParty id"  
	lappend csv_content "Party Name"  
	lappend csv_content "Grade"  
	lappend csv_content "Comments/Edit reason"
	
	if { $number_of_members == 1 } {
		# the task is individual

		set sql_query "select cu.person_id as party_id, cu.last_name||' - '||cu.first_names as party_name,  
                                        ese.grade,
                                        ese.description as comments
                  from cc_users cu left outer join evaluation_student_evalsi ese on (ese.party_id = cu.person_id
                                                                                    and ese.task_id = :task_id
                                                                                    and content_revision__is_live(ese.evaluation_id) = true)" 
	} else { 
		# the task is in groups
		
		set sql_query "select etg.group_id as party_id, g.group_name as party_name,  
                                        ese.grade,
                                        ese.description as comments
                  from groups g,
                       evaluation_task_groups etg left outer join evaluation_student_evalsi ese on (ese.party_id = etg.group_id
                                                                                    and ese.task_id = :task_id
                                                                                    and content_revision__is_live(ese.evaluation_id) = true)
                  where etg.task_id = :task_id
                    and etg.group_id = g.group_id"
	}
	
	db_foreach parties_with_to_grade $sql_query {
		lappend csv_content "\n$party_id" 
		lappend csv_content "$party_name" 
		lappend csv_content "$grade" 
		lappend csv_content "$comments" 
	} if_no_rows { 
		ad_return_error "No parties to grade" "In order to generate this file there must be some parties assigned to this task"
		return 
	} 
	
    set csv_formatted_content [join $csv_content ","] 
	
    doc_return 200 text/csv " 
    $csv_formatted_content" 
}

 
ad_register_proc GET /grades-sheet-csv* evaluation::generate_grades_sheet 
ad_register_proc POST /grades-sheet-csv* evaluation::generate_grades_sheet
