ad_library {
    Procedures in the evaluation namespace.
    
    @creation-date Feb 2004
    @author jopez@galileo.edu
    @cvs-id $Id$
}

namespace eval evaluation {}
namespace eval evaluation::notification {}
namespace eval evaluation::apm {}

#####
#
#  evaluation namespace
#
#####

ad_proc -public evaluation::notification::get_url { 
    -task_id:required
    -notif_type:required
    {-evaluation_id ""}
} { 
	returns a full url to the object_id. 
	handles assignments and evaluations. 
} {  
 
    set base_url "[ad_url][ad_conn package_url]" 
    switch $notif_type {
	"one_assignment_notif" {
	    db_1row get_grade_id { *SQL* }
	    return [export_vars -base "${base_url}task-view" { task_id grade_id }]
	} 
	"one_evaluation_notif" {
	    set evaluation_mode display
	    return [export_vars -base "${base_url}admin/evaluations/one-evaluation-edit" { task_id evaluation_id evaluation_mode }]
	} 
	default {
	    error "Unrecognized value for notif type: $notif_type. Possible values are one_assignment_notif and one_evaluation_notif." 
	    ad_script_abort
	}
    }
} 

ad_proc -public evaluation::notification::do_notification { 
    -task_id:required
    -package_id:required
    -notif_type:required
    {-evaluation_id ""}
    {-edit_p 0}
} {  

    db_1row select_names { *SQL* } 
    
    switch $notif_type {
	"one_assignment_notif" { 	    
	    if { [string eq $edit_p 0] } {
		set notif_subject "New Assignment ($grade_name)"
		set notif_text "A new assignment was uploaded, if you want to see more details \n"
	    } else {
		set notif_subject "Assignment Edited ($grade_name)"
		set notif_text "An assignment was modified, if you want to see more details \n"
	    }
	    append notif_text "click on this link: [evaluation::notification::get_url -task_id $task_id -notif_type one_assignment_notif] \n"
	    set response_id $task_id
	    
	}
	"one_evaluation_notif" {
	    db_1row get_eval_info { *SQL* }
	    set user_name [person::name -person_id [ad_conn user_id]]
	    set notif_subject "Evaluation Modified"
	    set notif_text "$user_name has modified the grade of ${party_name}. \n The edit reason given by $user_name was: $edit_reason \n The current grade is: $current_grade \n\n Click on this link to see the evaluation details: [evaluation::notification::get_url -task_id $task_id -evaluation_id $evaluation_id -notif_type one_evaluation_notif] \n"
	    set response_id $evaluation_id
	}
	default {
	    error "Unrecognized value for notif type: $notif_type. Possible values are one_assignment_notif and one_evaluation_notif." 
	    ad_script_abort
	}
    }
    
    # Notifies the users that requested notification for the specific object
    
    notification::new \
	-type_id [notification::type::get_type_id -short_name $notif_type] \
	-object_id $package_id \
	-response_id $response_id \
	-notif_subject $notif_subject \
	-notif_text $notif_text 
} 

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
    -plural_name:required
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

ad_proc -public evaluation::clone_task {
    -item_id:required
    -from_task_id:required
    -to_grade_id:required
    -to_package_id:required
} {
    Cone a task

    @param item_id The item to create.
    @param from_task_id Task to clon.
    @param to_grade_id Grade that will "own" the task
} {

    db_1row from_task_info { *SQL* }

    set creation_user [ad_conn user_id]
    set creation_ip [ad_conn peeraddr]

    set item_name "${item_id}_${title}"

    set revision_id [db_nextval acs_object_id_seq]

    db_exec_plsql content_item_new { *SQL* }

    db_exec_plsql content_revision_new { *SQL* }

    db_dml clone_content { *SQL* }
    return $revision_id
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
	set creation_user [ad_conn user_id]
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

	lappend csv_content "\n\nId"  
	lappend csv_content "Name"  
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

ad_proc -private evaluation::apm::delete_one_assignment_impl {} {
    Unregister the NotificationType implementation for one_assignment_notif_type.
} {
    acs_sc::impl::delete \
        -contract_name "NotificationType" \
        -impl_name one_assignment_notif_type
}

ad_proc -private evaluation::apm::delete_one_evaluation_impl {} {
    Unregister the NotificationType implementation for one_evaluation_notif_type.
} {
    acs_sc::impl::delete \
        -contract_name "NotificationType" \
        -impl_name one_evaluation_notif_type
}

ad_proc -private evaluation::apm::create_one_assignment_impl {} {
    Register the service contract implementation and return the impl_id
    @return impl_id of the created implementation 
} {
    return [acs_sc::impl::new_from_spec -spec {
	name one_assignment_notif_type
	contract_name NotificationType
	owner evaluation
	aliases {
	    GetURL evaluation::notification::get_url
	    ProcessReply evaluation::notification::process_reply
	}
    }]
}

ad_proc -private evaluation::apm::create_one_evaluation_impl {} {
    Register the service contract implementation and return the impl_id
    @return impl_id of the created implementation 
} {
    return [acs_sc::impl::new_from_spec -spec {
	name one_evaluation_notif_type
	contract_name NotificationType
	owner evaluation
	aliases {
	    GetURL evaluation::notification::get_url
	    ProcessReply evaluation::notification::process_reply
	}
    }]
}
 
ad_proc -private evaluation::apm::create_one_assignment_type {
    -impl_id:required
} {
    Create the notification type for one specific assignment
    @return the type_id of the created type
} {
    return [notification::type::new \
		-sc_impl_id $impl_id \
		-short_name one_assignment_notif \
		-pretty_name "One Assignment" \
		-description "Notification for assignments"]
}

ad_proc -private evaluation::apm::create_one_evaluation_type {
    -impl_id:required
} {
    Create the notification type for one specific evaluation
    @return the type_id of the created type
} {
    return [notification::type::new \
		-sc_impl_id $impl_id \
		-short_name one_evaluation_notif \
		-pretty_name "One Evaluation" \
		-description "Notification for evaluations"]
}

ad_proc -public evaluation::apm::enable_intervals_and_methods {
    -type_id:required
} {
    Enable the intervals and delivery methods of a specific type
} {
    # Enable the various intervals and delivery method
    notification::type::interval_enable \
	-type_id $type_id \
	-interval_id [notification::interval::get_id_from_name -name instant]
    
    notification::type::interval_enable \
	-type_id $type_id \
	-interval_id [notification::interval::get_id_from_name -name hourly]
    
    notification::type::interval_enable \
	-type_id $type_id \
	-interval_id [notification::interval::get_id_from_name -name daily]
    
    # Enable the delivery methods
    notification::type::delivery_method_enable \
	-type_id $type_id \
	-delivery_method_id [notification::delivery::get_id -short_name email]
}

ad_proc -public evaluation::apm::create_folders {
    -package_id:required
} {
    Helper for the apm_proc
} {
    db_transaction {
	db_exec_plsql create_evaluation_folders { *SQL* }

	set creation_user [ad_verify_and_get_user_id]
	set creation_ip [ad_conn peeraddr]
	
	set exams_item_id [db_nextval acs_object_id_seq]
	set exams_item_name "evaluation_grades_${exams_item_id}"		
	set exams_revision_id [db_nextval acs_object_id_seq]
	set exams_revision_name "evaluation_grades_${exams_revision_id}"
	
	db_exec_plsql exams_item_new { *SQL* }
	
	db_exec_plsql exams_revision_new { *SQL* }
	
	db_exec_plsql exams_live_revision { *SQL* }
	
	set projects_item_id [db_nextval acs_object_id_seq]
	set projects_item_name "evaluation_grades_${projects_item_id}"		
	set projects_revision_id [db_nextval acs_object_id_seq]
	set projects_revision_name "evaluation_grades_${projects_revision_id}"
	
	db_exec_plsql projects_item_new { *SQL* }
	
	db_exec_plsql projects_revision_new { *SQL* }

	db_exec_plsql projects_live_revision { *SQL* }
	
	set tasks_item_id [db_nextval acs_object_id_seq]
	set tasks_item_name "evaluation_grades_${tasks_item_id}"		
	set tasks_revision_id [db_nextval acs_object_id_seq]
	set tasks_revision_name "evaluation_grades_${tasks_revision_id}"
	
	db_exec_plsql tasks_item_new { *SQL* }
	
	db_exec_plsql tasks_revision_new { *SQL* }
	
	db_exec_plsql tasks_live_revision { *SQL* }

    }
}

ad_proc -public evaluation::apm::delete_contents {
    -package_id:required
} {
    Helper for the apm_proc
} {

    set ev_grades_fid [db_string get_f_id "select content_item__get_id('evaluation_grades_'||:package_id,null,'f')"]
    set ev_grades_sheets_fid [db_string get_f_id "select content_item__get_id('evaluation_grades_sheets_'||:package_id,null,'f')"]
    set ev_tasks_fid [db_string get_f_id "select content_item__get_id('evaluation_tasks_'||:package_id,null,'f')"]
    set ev_tasks_sols_fid [db_string get_f_id "select content_item__get_id('evaluation_tasks_sols_'||:package_id,null,'f')"]
    set ev_answers_fid [db_string get_f_id "select content_item__get_id('evaluation_answers_'||:package_id,null,'f')"]
    set ev_student_evals_fid [db_string get_f_id "select content_item__get_id('evaluation_student_evals_'||:package_id,null,'f')"]

    db_transaction {
	db_exec_plsql delte_evaluation_contents { *SQL* }
	
	db_exec_plsql delte_grades_sheets_folder { *SQL* }
	
	db_exec_plsql delte_grades_folder { *SQL* }
	
	db_exec_plsql delte_task_folder { *SQL* }
	
	db_exec_plsql delte_task_sols_folder { *SQL* }
	
	db_exec_plsql delte_answers_folder { *SQL* }

	db_exec_plsql delte_evals_folder { *SQL* }
    }
}

ad_proc -public evaluation::get_archive_command {
    {-in_file ""}
    {-out_file ""}
} {
    return the archive command after replacing {in_file} and {out_file} with
    their respective values.
} {
    set cmd [parameter::get -parameter ArchiveCommand -default "cat `find {in_file} -type f` > {out_file}"]
    
    regsub -all {(\W)} $in_file {\\\1} in_file
    regsub -all {\\/} $in_file {/} in_file
    regsub -all {\\\.} $in_file {.} in_file
    
    regsub -all {(\W)} $out_file {\\\1} out_file
    regsub -all {\\/} $out_file {/} out_file
    regsub -all {\\\.} $out_file {.} out_file
    
    regsub -all {{in_file}} $cmd $in_file cmd
    regsub -all {{out_file}} $cmd $out_file cmd
    
    return $cmd
}

ad_proc -public evaluation::public_answers_to_file_system {
    -task_id:required
    -path:required
    -folder_name:required
} {
    Writes all the answers of a given task in the file sytem.
} {

    set dir [file join ${path} ${folder_name}]
    file mkdir $dir

    db_foreach get_answers_for_task { *SQL* } {
	if { [string eq $storage_type "lob"] } {
	    # it is a file
	    
	    regsub -all {[<>:\"|/@\\\#%&+\\ ,]} $party_name {_} file_name
	    append file_name [file extension $answer_title]
	    
	    db_blob_get_file select_object_content { *SQL* } -file [file join ${dir} ${file_name}]
	    
	} else {
	    # it is a url

	    set url [db_string url { *SQL* }]

	    
	    set file_name "${party_name}.url"
	    
	    regsub -all {[<>:\"|/@\\\#%&+\\ ,]} $file_name {_} file_name
	    set fp [open [file join ${dir} ${file_name}] w]
	    puts $fp {[InternetShortcut]}
	    puts $fp URL=$url
	    close $fp
	}
    }

    return $dir
}

ad_proc -public evaluation::get_archive_extension {} {
    return the archive extension that should be added to the output file of
    an archive command
} {
    return [parameter::get -parameter ArchiveExtension -default "txt"]
}

ad_register_proc GET /grades-sheet-csv* evaluation::generate_grades_sheet 
ad_register_proc POST /grades-sheet-csv* evaluation::generate_grades_sheet
