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
	    error "[_ evaluation.lt_Unrecognized_value_fo]" 
	    ad_script_abort
	}
    }
} 

ad_proc -public evaluation::get_user_portrait { 
    -user_id:required
    {-tag_attributes ""}
} { 
    returns the portrait for the given user or a default portrait if not found.
} {  
    
    if { [db_0or1row user_portrait { *SQL* }] } {
	set output "<img src=\"/shared/portrait-bits.tcl?user_id=$user_id\" "
    } else {
	set output "<img src=\"[lindex [site_node::get_url_from_object_id -object_id [ad_conn package_id]] 0]resources/photo_na.gif\" "
    }

    if { ![empty_string_p $tag_attributes] } {
	for {set i 0} { $i < [ns_set size $tag_attributes] } { incr i } {
	    set attribute_name [ns_set key $tag_attributes $i]
	    set attribute_value [ns_set value $tag_attributes $i]
	    
	    if { [string equal $attribute_name {}] } {
		append output " $attribute_name"
	    } else {
		append output " $attribute_name=\"$attribute_value\""
	    }
	}
    }

    append output ">"
    return $output
} 

ad_proc -public evaluation::safe_url_name { 
    -name:required
} { 
    returns the filename replacing some characters
} {  

    regsub -all {[<>:\"|/@\\\#%&+\\ ,\?]} $name {_} name
    return $name

} 


ad_proc -public evaluation::delete_grade {
    -grade_id:required
} {
    delete all grades
} {
   db_1row get_grade_id { select grade_item_id from evaluation_grades where grade_id = :grade_id}
   db_foreach del_rec { select task_item_id from evaluation_tasks where grade_item_id = :grade_item_id } {
     db_foreach evaluation_delete_student_eval { select evaluation_id from evaluation_student_evals where task_item_id = :task_item_id } {
     content::revision::delete -revision_id $evaluation_id
     }
     db_foreach evaluation_delete_answer { select answer_id from evaluation_answers where task_item_id = :task_item_id } {
     content::revision::delete -revision_id $answer_id
     }
     db_foreach evaluation_delete_task_sol { select solution_id from evaluation_tasks_sols where task_item_id = :task_item_id } {
     content::revision::delete -revision_id $solution_id
     }
     db_foreach evaluation_delete_grades_sheet { select grades_sheet_id from evaluation_grades_sheets where task_item_id = :task_item_id } {
     content::revision::delete -revision_id $grades_sheet_id
     }
     db_foreach evaluation_delete_task { select task_id from evaluation_tasks where task_item_id = :task_item_id } {
     content::revision::delete -revision_id $task_id                                                                                                              }
     }
#    db_1row get_grade_id { select grade_id as grade_task_id from evaluation_grades where grade_item_id = :grade_item_id}
     content::revision::delete -revision_id $grade_id
}

ad_proc -public evaluation::delete_task {
    -task_id:required
} {
    delete all tasks
} {
     db_1row get_grade_id { select task_item_id from evaluation_tasks where task_id = :task_id}
     db_foreach evaluation_delete_student_eval { select evaluation_id from evaluation_student_evals where task_item_id = :task_item_id } {
     content::revision::delete -revision_id $evaluation_id
     }
     db_foreach evaluation_delete_answer { select answer_id from evaluation_answers where task_item_id = :task_item_id } {
     content::revision::delete -revision_id $answer_id
     }
     db_foreach evaluation_delete_task_sol { select solution_id from evaluation_tasks_sols where task_item_id = :task_item_id } {
     content::revision::delete -revision_id $solution_id
     }
     db_foreach evaluation_delete_grades_sheet { select grades_sheet_id from evaluation_grades_sheets where task_item_id = :task_item_id } {
     content::revision::delete -revision_id $grades_sheet_id
     }
#    db_1row get_task_id { select task_id as tasks_task_id from evaluation_tasks where task_item_id = :task_item_id }
     content::revision::delete -revision_id $task_id
}

ad_proc -public evaluation::delete_student_eval1 {
    -evaluation_id:required
} {
    delete all tasks
} {
     content::revision::delete -revision_id $evaluation_id
}

ad_proc -public evaluation::notification::do_notification { 
    -task_id:required
    -package_id:required
    -notif_type:required
    {-evaluation_id ""}
    {-edit_p 0}
} {  

    db_1row select_names { *SQL* } 
    
    set community_name ""
    set community_id [dotlrn_community::get_community_id]
    if { ![empty_string_p $community_id] } {
	set community_name [db_string get_community_name "select pretty_name from dotlrn_communities_all where community_id = :community_id"]
    } 

    switch $notif_type {
	"one_assignment_notif" { 	    
	    if { [string eq $edit_p 0] } {
		set notif_subject "[_ evaluation.lt_New_Assignment_grade_]"
		set notif_text "[_ evaluation.lt_A_new_assignment_was_] \n"
	    } else {
		set notif_subject "[_ evaluation.lt_Assignment_Edited_gra]"
		set notif_text "[_ evaluation.lt_An_assignment_was_mod] \n"
	    }
	    append notif_text "[_ evaluation.click_on_this_link_] [evaluation::notification::get_url -task_id $task_id -notif_type one_assignment_notif] \n"
	    set response_id $task_id
	    
	}
	"one_evaluation_notif" {
	    db_1row get_eval_info { *SQL* }
	    set user_name [person::name -person_id [ad_conn user_id]]
	    set notif_subject "[_ evaluation.lt_Evaluation_Modified_c]"
	    set url_link [evaluation::notification::get_url -task_id $task_id -evaluation_id $evaluation_id -notif_type one_evaluation_notif]
	    set notif_text "[_ evaluation.lt_user_name_has_modifie]"
	    set response_id $evaluation_id
	}
	default {
	    error "[_ evaluation.lt_Unrecognized_value_fo]" 
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
#    set folder_id [content::folder::new -name "$content_type_$package_id" -label "$content_type_$package_id" -package_id $package_id ]
    set folder_id [db_exec_plsql get_folder_id {select content_item__get_id(:content_type||'_'||:package_id,null,'f')}]
    if { $new_item_p } {
         set item_id [content::item::new -item_id $item_id -parent_id $folder_id -content_type $content_type -name $item_name -context_id $package_id]
    }
        set revision_id [content::revision::new \
                                  -item_id $item_id \
                                  -content_type $content_type \
                                  -description $description \
                                  -attributes [list [list weight $weight] \
                                                    [list grade_name $name] \
                                                    [list comments  $description] \                                                                                                                              [list grade_item_id  $item_id] \
                                                    [list grade_plural_name $plural_name]] ]  
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
    
    # set default time
    set now [lreplace $now 3 3 23]    
    set now [lreplace $now 4 4 59]    
    set now [lreplace $now 5 5 59]    
    
    return [eval template::util::date::create $now]
}

ad_proc -public evaluation::clone_task {
    -item_id:required
    -from_task_id:required
    -to_grade_item_id:required
    -to_package_id:required
} {
    Cone a task

    @param item_id The item to create.
    @param from_task_id Task to clone.
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
    -grade_item_id:required
    -number_of_members:required
    -requires_grade_p:required
    -storage_type:required
    {-estimated_time 0}
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
    @param grade_item_id Grade type where the task belongs
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
#    set folder_id [content::folder::new -name "$content_type_$package_id" -label "$content_type_$package_id" -package_id $package_id ]
    set folder_id [db_exec_plsql get_folder_id {select content_item__get_id(:content_type||'_'||:package_id,null,'f')}]
    if { [empty_string_p $item_name] } {
	set item_name "${item_id}_${title}"
    }
    set revision_id [db_nextval acs_object_id_seq]
    if { $new_item_p } {
#	db_exec_plsql content_item_new { *SQL* }
    set item_id [content::item::new -item_id $item_id -parent_id $folder_id -content_type {evaluation_tasks} -name $item_name -context_id $package_id -mime_type $mime_type -title $title -storage_type $storage_type] 
    }
    set revision_id [content::revision::new \
                             -item_id $item_id \
                             -content_type {evaluation_tasks} \
                             -mime_type $mime_type \
			     -title $title \
                             -description $description \
                             -attributes [list [list weight $weight] \                                                                                                                                      [list task_name $name] \                                                                                                                                     [list task_item_id $item_id] \                                                                                                                               [list online_p $online_p] \                                                                                                                                  [list grade_item_id $grade_item_id] \                                                                                                                        [list due_date $due_date] \                                                                                                                                  [list late_submit_p $late_submit_p] \                                                                                                                        [list requires_grade_p $requires_grade_p] \                                                                                                                  [list number_of_members $number_of_members]] ]   

 #   db_exec_plsql content_revision_new { *SQL* }
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
    -task_item_id:required
    -storage_type:required
    -title:required
    {-mime_type "text/plain"}
    {-publish_date ""}
    {-creation_date ""}
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
    @param storage_type lob, file or text, depending on what are we going to store

} {

    set package_id [ad_conn package_id]
    set creation_user [ad_verify_and_get_user_id]
    set creation_ip [ad_conn peeraddr]
    #set folder_id [content::folder::new -name "$content_type_$package_id" -label "$content_type_$package_id" -package_id $package_id ]
    set folder_id [db_exec_plsql get_folder_id {select content_item__get_id(:content_type||'_'||:package_id,null,'f')}]
    set item_name "${item_id}_${title}"

    set revision_id [db_nextval acs_object_id_seq]

    if { [empty_string_p $publish_date] } {
	set publish_date [db_string get_publish_date "select now()"]
    }

    if { [empty_string_p $creation_date] } {
	set creation_date [db_string get_creation_date "select now()"]
    }

    if { $new_item_p } {
#	db_exec_plsql content_item_new { *SQL* }
        set item_id [content::item::new -item_id $item_id -parent_id $folder_id -content_type $content_type -name $item_name -context_id $package_id -mime_type $mime_type -storage_type $storage_type -title $title]
    }
        set revision_id [content::revision::new \
                                  -item_id $item_id \
                                  -content_type $content_type \
                                  -mime_type $mime_type \
				  -title $title \
                                  -attributes [list [list task_item_id  $task_item_id] \
                                                    [list solution_item_id $item_id]] ]

#    db_exec_plsql content_revision_new { *SQL* }

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
    -task_item_id:required
    -storage_type:required
    -title:required
    -party_id:required
    {-mime_type "text/plain"}
    {-publish_date ""}
    {-creation_date ""}
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
    @param storage_type lob, file or text, depending on what are we going to store
    @param party_id Group or user_id thaw owns the anser
} {

    set package_id [ad_conn package_id]
    set creation_user [ad_verify_and_get_user_id]
    set creation_ip [ad_conn peeraddr]
    #set folder_id [content::folder::new -name "$content_type_$package_id" -label "$content_type_$package_id" -package_id $package_id ]
    set folder_id [db_exec_plsql get_folder_id {select content_item__get_id(:content_type||'_'||:package_id,null,'f')}]
    set item_name "${item_id}_${title}"

    set revision_id [db_nextval acs_object_id_seq]

    if { [empty_string_p $publish_date] } {
	set publish_date [db_string get_publish_date "select now()"]
    }

    if { [empty_string_p $creation_date] } {
	set creation_date [db_string get_creation_date "select now()"]
    }

    if { $new_item_p } {
#	db_exec_plsql content_item_new { *SQL* }
        set item_id [content::item::new -item_id $item_id -parent_id $folder_id -content_type $content_type -name $item_name -context_id $package_id -mime_type $mime_type -title $title -storage_type $storage_type]

    }  
#    db_exec_plsql content_revision_new { *SQL* }
        set revision_id [content::revision::new \
                                  -item_id $item_id \
                                  -content_type $content_type \
                                  -mime_type $mime_type \
				  -title $title\
                                  -attributes [list [list answer_item_id  $item_id] \
						    [list party_id $party_id] \
                                                    [list task_item_id $task_item_id]] ]
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
    -task_item_id:required
    -grade:required
    {-title "evaluation"}
    {-show_student_p "t"}
    {-storage_type "text"}
    {-description ""}
    {-mime_type "text/plain"}
    {-publish_date ""}
    {-creation_date ""}
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
    @param storage_type lob, file or text, depending on what are we going to store
    @param description Comments on the evaluation
    @param mime_type Mime type of the evaluation.
} {

    set package_id [ad_conn package_id]
    set creation_user [ad_verify_and_get_user_id]
    set creation_ip [ad_conn peeraddr]
    #set folder_id [content::folder::new -name "$content_type_$package_id" -label "$content_type_$package_id" -package_id $package_id ]
    set folder_id [db_exec_plsql get_folder_id {select content_item__get_id(:content_type||'_'||:package_id,null,'f')}]
    set item_name "${item_id}_${title}"

    set revision_id [db_nextval acs_object_id_seq]

    if { [empty_string_p $publish_date] } {
	set publish_date [db_string get_publish_date "select now()"]
    }

    if { [empty_string_p $creation_date] } {
	set creation_date [db_string get_creation_date "select now()"]
    }

    if { $new_item_p } {
#	db_exec_plsql content_item_new { *SQL* }
        set item_id [content::item::new -item_id $item_id -parent_id $folder_id -content_type $content_type -name $item_name -context_id $package_id -mime_type $mime_type -title $title -storage_type $storage_type]
    }   
#       db_exec_plsql content_revision_new { *SQL* }
        set revision_id [content::revision::new \
                                  -item_id $item_id \
                                  -content_type $content_type \
                                  -mime_type $mime_type \
                                  -title $title\
                                  -attributes [list [list evaluation_item_id  $item_id] \
                                                    [list party_id $party_id] \
						    [list grade $grade] \
						    [list show_student_p $show_student_p] \
                                                    [list task_item_id $task_item_id]] ]

} 
ad_proc -public evaluation::new_evaluation_group {
    -group_id:required
    -group_name:required
    -task_item_id:required
    {-context ""}
    {-creation_date ""}
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

    if { [empty_string_p $creation_date] } {
	set creation_date [db_string get_creation_date "select now()"]
    }

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
    -task_item_id:required
    -storage_type:required
    -title:required
    -mime_type:required
    {-creation_date ""}
    {-publish_date ""}
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
    @param storage_type lob or file 
    @param mime_type Mime tipe of the grades sheet

} {

    set package_id [ad_conn package_id]
    set creation_user [ad_verify_and_get_user_id]
    set creation_ip [ad_conn peeraddr]
    #set folder_id [content::folder::new -name "$content_type_$package_id" -label "$content_type_$package_id" -package_id $package_id ]
    set folder_id [db_exec_plsql get_folder_id {select content_item__get_id(:content_type||'_'||:package_id,null,'f')}]
    set item_name "${item_id}_${title}"

    set revision_id [db_nextval acs_object_id_seq]

    if { [empty_string_p $publish_date] } {
	set publish_date [db_string get_publish_date "select now()"]
    }

    if { [empty_string_p $creation_date] } {
	set creation_date [db_string get_creation_date "select now()"]
    }

    if { $new_item_p } {
#db_exec_plsql content_item_new { *SQL* }
        set item_id [content::item::new -item_id $item_id -parent_id $folder_id -content_type $content_type -name $item_name -context_id $package_id -mime_type $mime_type -title $title -storage_type $storage_type]

    }   
#db_exec_plsql content_revision_new { *SQL* }
        set revision_id [content::revision::new \
                                  -item_id $item_id \
                                  -content_type $content_type \
				  -title $title \
                                  -mime_type $mime_type \
                                  -attributes [list [list grades_sheet_item_id  $item_id] \
                                                    [list task_item_id $task_item_id]] ]
    return $revision_id
} 

ad_proc -public evaluation::generate_grades_sheet {} {

    # Get file_path from url 
    set url [ns_conn url] 
    
    regexp {/grades-sheet-csv-([^.]+).csv$} $url match task_id  
    
    if { ![db_0or1row get_task_info { *SQL* }] } { 
	# this should never happen
        ad_return_error "No information" "There has been an error, there is no infomraiton about the task $task_id"
        return 
    } 
    
    set csv_content [list] 
    lappend csv_content "[_ evaluation.lt_Grades_sheet_for_assi]"  

    lappend csv_content "\n[_ evaluation.Max_Grade_]"
    lappend csv_content "100"
    lappend csv_content "\n[_ evaluation.lt_Will_the_student_be_a]"
    lappend csv_content "1"

    lappend csv_content "\n\n[_ evaluation.Id_]"  
    lappend csv_content "[_ evaluation.Name_]"  
    lappend csv_content "[_ evaluation.Grade_]"  
    lappend csv_content "[_ evaluation.CommentsEdit_reason_]"
    
    if { $number_of_members == 1 } {
	# the task is individual

	set community_id [dotlrn_community::get_community_id]
	if { [empty_string_p $community_id] } {
	    set sql_query [db_map sql_query_individual] 
	} else {
	    set sql_query [db_map sql_qyery_comm_ind]
	}

    } else { 
	# the task is in groups
	
	set sql_query [db_map sql_query_groups]
    }
    
    db_foreach parties_with_to_grade { *SQL* } {
	if { ![empty_string_p $grade] } {
	    set grade [lc_numeric $grade]
	}
	lappend csv_content "\n$party_id" 
	lappend csv_content "$party_name" 
	lappend csv_content "$grade" 
	lappend csv_content "$comments" 
    } if_no_rows { 
	ad_return_error "[_ evaluation.No_parties_to_grade_]" "[_ evaluation.lt_In_order_to_generate_]"
	return 
    } 
    
    set csv_formatted_content [join $csv_content ","] 
    
    doc_return 200 text/csv " 
    $csv_formatted_content" 
}

ad_proc -public evaluation::apm::delete_one_assignment_impl {} {
    Unregister the NotificationType implementation for one_assignment_notif_type.
} {
    acs_sc::impl::delete \
        -contract_name "NotificationType" \
        -impl_name one_assignment_notif_type
}

ad_proc -public evaluation::apm::delete_one_evaluation_impl {} {
    Unregister the NotificationType implementation for one_evaluation_notif_type.
} {
    acs_sc::impl::delete \
        -contract_name "NotificationType" \
        -impl_name one_evaluation_notif_type
}

ad_proc -public evaluation::apm::create_one_assignment_impl {} {
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

ad_proc -public evaluation::apm::create_one_evaluation_impl {} {
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

ad_proc -public evaluation::apm::create_one_assignment_type {
    -impl_id:required
} {
    Create the notification type for one specific assignment
    @return the type_id of the created type
} {
    return [notification::type::new \
		-sc_impl_id $impl_id \
		-short_name one_assignment_notif \
		-pretty_name "[_ evaluation.One_Assignment_]" \
		-description "[_ evaluation.lt_Notification_for_assi]"]
}

ad_proc -public evaluation::apm::create_one_evaluation_type {
    -impl_id:required
} {
    Create the notification type for one specific evaluation
    @return the type_id of the created type
} {
    return [notification::type::new \
		-sc_impl_id $impl_id \
		-short_name one_evaluation_notif \
		-pretty_name "[_ evaluation.One_Evaluation_]" \
		-description "[_ evaluation.lt_Notification_for_eval]"]
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
	set exams_name "[_ evaluation.Exams_]"
	set exams_singular_name "[_ evaluation.Exam]"
	set exams_desc "[_ evaluation.Exams_for_students_]"
	set tasks_name "[_ evaluation.Tasks_]"
	set tasks_singular_name "[_ evaluation.Task]"
	set tasks_desc "[_ evaluation.Tasks_for_students_]"
	set projects_name "[_ evaluation.Projects_]"
	set projects_singular_name "[_ evaluation.Project]"
	set projects_desc "[_ evaluation.lt_Projects_for_students]"
        set folder_id [content::folder::new -name "evaluation_grades_$package_id" -label "evaluation_grades_$package_id" -package_id $package_id ]
	content::folder::register_content_type -folder_id $folder_id -content_type {evaluation_grades} -include_subtypes t

        set folder_id [content::folder::new -name "evaluation_tasks_$package_id" -label "evaluation_tasks_$package_id" -package_id $package_id ]
        content::folder::register_content_type -folder_id $folder_id -content_type {evaluation_tasks} -include_subtypes t

        set folder_id [content::folder::new -name "evaluation_tasks_sols_$package_id" -label "evaluation_tasks_sols_$package_id" -package_id $package_id ]
        content::folder::register_content_type -folder_id $folder_id -content_type {evaluation_tasks_sols} -include_subtypes t

        set folder_id [content::folder::new -name "evaluation_answers_$package_id" -label "evaluation_answers_$package_id" -package_id $package_id ]
        content::folder::register_content_type -folder_id $folder_id -content_type {evaluation_answers} -include_subtypes t

        set folder_id [content::folder::new -name "evaluation_grades_sheets_$package_id" -label "evaluation_grades_sheets_$package_id" -package_id $package_id ]
        content::folder::register_content_type -folder_id $folder_id -content_type {evaluation_grades_sheets} -include_subtypes t

        set folder_id [content::folder::new -name "evaluation_student_evals_$package_id" -label "evaluation_student_evals_$package_id" -package_id $package_id ]
        content::folder::register_content_type -folder_id $folder_id -content_type {evaluation_student_evals} -include_subtypes t
    }
}

ad_proc -public evaluation::apm::delete_contents {
    -package_id:required
} {
    Helper for the apm_proc
} {
#Delete all content templates
ns_log notice "Por Aqui paso esto"
db_foreach v1 { select ea.answer_id from evaluation_answersi ea, acs_objects ao where ea.item_id = ao.object_id and ao.context_id = p_package_id } {
content::revision::delete -revision_id $answer_id
}
db_foreach v2 { select ets.solution_id from evaluation_tasks_solsi ets, acs_objects ao where ets.item_id = ao.object_id and ao.context_id = p_package_id  } { content::revision::delete -revision_id $solution_id }
db_foreach v3 { select egs.grades_sheet_id from evaluation_grades_sheetsi egs, acs_objects ao where egs.item_id = ao.object_id and ao.context_id = p_package_id  } {
content::revision::delete -revision_id $grades_sheet_id }
db_foreach v4 { select ese.evaluation_id from evaluation_student_evalsi ese, acs_objects ao where ese.item_id = ao.object_id and ao.context_id = p_package_id  } {
content::revision::delete -revision_id $evaluation_id }
db_foreach v5 { select et.task_id from evaluation_tasksi et, acs_objects ao where et.item_id = ao.object_id and ao.context_id = p_package_id  } {
content::revision::delete -revision_id $task_id }
db_foreach v6 { select eg.grade_id from evaluation_gradesi eg, acs_objects ao where eg.item_id = ao.object_id and ao.context_id = p_package_id  } {
content::revision::delete -revision_id $grade_id}

#Evaluation_Task_Sols
ns_log notice "Eliminado folder de Evaluation_Task_Sols"
set v_folder_id [content::item::get_id -item_path "evaluation_tasks_sols_$package_id" -resolve_index {f}]
ns_log notice "Numero de Folder $v_folder_id este es el numero"
db_foreach v11 { select item_id from cr_items where  parent_id = :v_folder_id } {
        evaluation::delete_grade -grade_item_id $item_id
}
content::folder::unregister_content_type -folder_id $v_folder_id  -content_type {content_revision} -include_subtypes {t}
content::folder::unregister_content_type -folder_id $v_folder_id  -content_type {evaluation_tasks_sols} -include_subtypes {t}
db_dml delete_v11 "delete from cr_folder_type_map where content_type = 'evaluation_tasks_sols'"
content::folder::delete -folder_id $v_folder_id
                                                                                                                                                             
#evaluation_answers
ns_log notice "Eliminando folder de evaluation_answer"
set v_folder_id [content::item::get_id -item_path "evaluation_answers_$package_id" -resolve_index {f}]
ns_log notice "Numero de Folder $v_folder_id este es el numero"
db_foreach v12 {select item_id from cr_items where  parent_id = :v_folder_id } {
        evaluation::delete_grade -grade_item_id $item_id }
content::folder::unregister_content_type -folder_id $v_folder_id -content_type {content_revision} -include_subtypes {t}
content::folder::unregister_content_type -folder_id $v_folder_id -content_type {evaluation_answers} -include_subtypes {t}
db_dml delete_v12 "delete from cr_folder_type_map where content_type = 'evaluation_answers'"
content::folder::delete -folder_id $v_folder_id
                                                                                                                                                             
#evaluation_students_eval
ns_log notice "Eliminando folder de evaluation_students_eval"
set v_folder_id [content::item::get_id -item_path "evaluation_student_evals_$package_id" -resolve_index {f}]
ns_log notice "Numero de Folder $v_folder_id este es el numero"
db_foreach v13 { select item_id from cr_items where  parent_id = :v_folder_id } {
       evaluation::delete_grade -grade_item_id $item_id }
content::folder::unregister_content_type -folder_id $v_folder_id -content_type {content_revision} -include_subtypes {t}
content::folder::unregister_content_type -folder_id $v_folder_id -content_type {evaluation_student_evals} -include_subtypes {t}
db_dml delete_v13 "delete from cr_folder_type_map where content_type = 'evaluation_student_evals'"
content::folder::delete -folder_id $v_folder_id
                                                                                                                                                             
#evaluation_grades_sheets
ns_log notice "Elimiando folder de evaluation_grades_sheets"
set v_folder_id [content::item::get_id -item_path "evaluation_grades_sheets_$package_id" -resolve_index {f}]
ns_log notice "Numero de Folder $v_folder_id este es el numero"
db_foreach v14 { select item_id  from cr_items where  parent_id = :v_folder_id } {
       evaluation::delete_grade -grade_item_id $item_id }
content::folder::unregister_content_type -folder_id $v_folder_id -content_type {content_revision} -include_subtypes {t}
content::folder::unregister_content_type -folder_id $v_folder_id -content_type {evaluation_grades_sheets} -include_subtypes {t}
db_dml delete_v14 "delete from cr_folder_type_map where content_type = 'evaluation_grades_sheets'"
content::folder::delete -folder_id $v_folder_id

#evaluation_tasks
ns_log notice "Elimando folder de evaluation_tasks"
set v_folder_id [content::item::get_id -item_path "evaluation_tasks_$package_id" -resolve_index {f}]
ns_log notice "Numero de Folder $v_folder_id este es el numero"
db_foreach v15 { select etg.group_id from evaluation_tasks et, evaluation_task_groups etg where etg.task_item_id = et.task_item_id } {
       evaluation::delete_grade -grade_item_id $item_id }
content::folder::unregister_content_type -folder_id $v_folder_id -content_type {content_revision} -include_subtypes {t}
content::folder::unregister_content_type -folder_id $v_folder_id -content_type {evaluation_tasks} -include_subtypes {t}
db_dml delete_v15 "delete from cr_folder_type_map where content_type = 'evaluation_tasks'"
content::folder::delete -folder_id $v_folder_id
                                                                                                                                                             
#evaluation_grades
ns_log notice "Elimando folder de evaluation_grades"
set v_folder_id [content::item::get_id -item_path "evaluation_grades_$package_id" -resolve_index {f}]
ns_log notice "Numero de Folder $v_folder_id este es el numero"
db_foreach v16 { select item_id from cr_items where  parent_id = :v_folder_id } {
       evaluation::delete_grade -grade_item_id $item_id }
content::folder::unregister_content_type -folder_id $v_folder_id -content_type {content_revision} -include_subtypes {t}
content::folder::unregister_content_type -folder_id $v_folder_id -content_type {evaluation_grades} -include_subtypes {t}
db_dml delete_v16 "delete from cr_folder_type_map where content_type = 'evaluation_grades'"
content::folder::delete -folder_id $v_folder_id


#    set ev_grades_fid [db_string get_f_id "select content_item__get_id('evaluation_grades_'||:package_id,null,'f')"]
#    set ev_grades_sheets_fid [db_string get_f_id "select content_item__get_id('evaluation_grades_sheets_'||:package_id,null,'f')"]
#    set ev_tasks_fid [db_string get_f_id "select content_item__get_id('evaluation_tasks_'||:package_id,null,'f')"]
#    set ev_tasks_sols_fid [db_string get_f_id "select content_item__get_id('evaluation_tasks_sols_'||:package_id,null,'f')"]
#    set ev_answers_fid [db_string get_f_id "select content_item__get_id('evaluation_answers_'||:package_id,null,'f')"]
#    set ev_student_evals_fid [db_string get_f_id "select content_item__get_id('evaluation_student_evals_'||:package_id,null,'f')"]

#    db_transaction {
#	db_exec_plsql delte_evaluation_contents { *SQL* }
	
#	db_exec_plsql delte_grades_sheets_folder { *SQL* }
	
#	db_exec_plsql delte_grades_folder { *SQL* }
	
#	db_exec_plsql delte_task_folder { *SQL* }
	
#	db_exec_plsql delte_task_sols_folder { *SQL* }
	
#	db_exec_plsql delte_answers_folder { *SQL* }

#	db_exec_plsql delte_evals_folder { *SQL* }
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
	if { [string eq $storage_type "lob"] || [string eq $storage_type "file"] } {
	    # it is a file
	    
	    regsub -all {[<>:\"|/@\\\#%&+\\ ,]} $party_name {_} file_name
	    append file_name [file extension $answer_title]
	    
	    if { [string eq $storage_type "file"] } {
		# its a file
		
		file copy -- "[cr_fs_path $cr_path]${cr_file_name}" [file join ${dir} ${file_name}]
	    } else {
		# its a lob
		db_blob_get_file select_object_content { *SQL* } -file [file join ${dir} ${file_name}]
	    }
	    
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
db_foreach get_answers_for_task}

ad_proc -public evaluation::get_archive_extension {} {
    return the archive extension that should be added to the output file of
    an archive command
} {
    return [parameter::get -parameter ArchiveExtension -default "txt"]
}

ad_register_proc GET /grades-sheet-csv* evaluation::generate_grades_sheet 
ad_register_proc POST /grades-sheet-csv* evaluation::generate_grades_sheet
