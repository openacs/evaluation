# /packages/evaluation/tcl/apm-callback-procs.tcl

ad_library {

    Evaluations Package APM callbacks library
    
    Procedures that deal with installing, instantiating, mounting.

    @creation-date Apr 2004
    @author jopez@galileo.edu
    @cvs-id $Id$
}

namespace eval evaluation {}
namespace eval evaluation::apm {}


ad_proc -public evaluation::apm::package_install {  
} {
    
    Does the integration whith the notifications package.  
} {
    db_transaction { 
	
	# Create the impl and aliases for one assignment
	set impl_id [create_one_assignment_impl]
	
	# Create the notification type for one assignment
	set type_id [create_one_assignment_type -impl_id $impl_id]
	
	# Enable the delivery intervals and delivery methods for a specific assignment
	enable_intervals_and_methods -type_id $type_id

	# Create the impl and aliases for one evaluation
	set impl_id [create_one_evaluation_impl]
	
	# Create the notification type for one evaluation
	set type_id [create_one_evaluation_type -impl_id $impl_id]
	
	# Enable the delivery intervals and delivery methods for a specific evaluation
	enable_intervals_and_methods -type_id $type_id
#Create the conten_type
content::type::new -content_type {evaluation_grades} -supertype {content_revision} -pretty_name {Evaluation Grade} -pretty_plural {Evaluation Grades} -table_name {evaluation_grades} -id_column {grade_id}
content::type::new -content_type {evaluation_tasks} -supertype {content_revision} -pretty_name {Evaluation Task} -pretty_plural {Evaluation Tasks} -table_name {evaluation_tasks} -id_column {task_id}
content::type::new -content_type {evaluation_tasks_sols} -supertype {content_revision} -pretty_name {Evaluation Task Solution} -pretty_plural {Evaluation Tasks Solutions} -table_name {evaluation_tasks_sols} -id_column {solution_id}
content::type::new -content_type {evaluation_answers} -supertype {content_revision} -pretty_name {Student Answer} -pretty_plural {Student Answers} -table_name {evaluation_answers} -id_column {answer_id}
content::type::new -content_type {evaluation_student_evals} -supertype {content_revision} -pretty_name {Student Evaluation} -pretty_plural {Student Evaluations} -table_name {evaluation_student_evals} -id_column {evaluation_id}
content::type::new -content_type {evaluation_grades_sheets} -supertype {content_revision} -pretty_name {Evaluation Grades Sheet} -pretty_plural {Evaluation Grades Sheets} -table_name {evaluation_grades_sheets} -id_column {grades_sheet_id}

#Create the new and register template
set template_id [content::template::new -name {evaluation-tasks-default}]
content::type::register_template -content_type {evaluation_tasks} -template_id $template_id -use_context {public} -is_default {t}
set template_id [content::template::new -name {evaluation-tasks-sols-default}]
content::type::register_template -content_type {evaluation_tasks_sols} -template_id $template_id -use_context {public} -is_default {t}
set template_id [content::template::new -name {evaluation-answers-default}]
content::type::register_template -content_type {evaluation_answers} -template_id $template_id -use_context {public} -is_default {t}
set template_id [content::template::new -name {evaluation-grades-sheets-default}]
content::type::register_template -content_type {evaluation_grades_sheets} -template_id $template_id -use_context {public} -is_default {t}

#evaluation_grades
content::type::attribute::new -content_type {evaluation_grades} -attribute_name {grade_item_id} -datatype {number}  -pretty_name {grade_item_id} -column_spec {integer}
content::type::attribute::new -content_type {evaluation_grades} -attribute_name {grade_name} -datatype {string}    -pretty_name {grade_name} -column_spec {varchar(100)}
content::type::attribute::new -content_type {evaluation_grades} -attribute_name {grade_plural_name} -datatype {string}    -pretty_name {grade_plural_name} -column_spec {varchar(100)}
content::type::attribute::new -content_type {evaluation_grades} -attribute_name {comments} -datatype {string}    -pretty_name {HTML display Options} -column_spec {varchar(500)}
content::type::attribute::new -content_type {evaluation_grades} -attribute_name {weight} -datatype {number}    -pretty_name { weight} -column_spec {numeric}
#evaluation_tasks
content::type::attribute::new -content_type {evaluation_tasks} -attribute_name {task_item_id} -datatype {number}  -pretty_name {task_item_id} -column_spec {integer}
content::type::attribute::new -content_type {evaluation_tasks} -attribute_name {task_name} -datatype {number}  -pretty_name {task_name} -column_spec {integer}
content::type::attribute::new -content_type {evaluation_tasks} -attribute_name {number_of_members} -datatype {string}  -pretty_name {number_of_members} -column_spec {varchar}
content::type::attribute::new -content_type {evaluation_tasks} -attribute_name {due_date} -datatype {number}  -pretty_name {due_date} -column_spec {timestamptz}
content::type::attribute::new -content_type {evaluation_tasks} -attribute_name {grade_item_id} -datatype {number}  -pretty_name {grade_item_id} -column_spec {integer}
content::type::attribute::new -content_type {evaluation_tasks} -attribute_name {weight} -datatype {number}  -pretty_name {weight} -column_spec {numeric}
content::type::attribute::new -content_type {evaluation_tasks} -attribute_name {online_p} -datatype {string}  -pretty_name {online_p} -column_spec {varchar(1)}
content::type::attribute::new -content_type {evaluation_tasks} -attribute_name {late_submit_p} -datatype {string}  -pretty_name {late_submit_p} -column_spec {varchar(1)}
content::type::attribute::new -content_type {evaluation_tasks} -attribute_name {requires_grade_p} -datatype {string}  -pretty_name {requires_grade_p} -column_spec {varchar(1)}
#evaluation_tasks_sols
content::type::attribute::new -content_type {evaluation_tasks_sols} -attribute_name {solution_item_id} -datatype {number}  -pretty_name {solution_item_id} -column_spec {integer}
content::type::attribute::new -content_type {evaluation_tasks_sols} -attribute_name {task_item_id} -datatype {number}  -pretty_name {task_item_id} -column_spec {integer}
#evaluation_answers
content::type::attribute::new -content_type {evaluation_answers} -attribute_name {answer_item_id} -datatype {number}  -pretty_name {answer_item_id} -column_spec {integer}
content::type::attribute::new -content_type {evaluation_answers} -attribute_name {party_id} -datatype {number}  -pretty_name {party_id} -column_spec {integer}
content::type::attribute::new -content_type {evaluation_answers} -attribute_name {task_item_id} -datatype {number}  -pretty_name {task_item_id} -column_spec {integer}
#evaluation_student_evals
content::type::attribute::new -content_type {evaluation_student_evals} -attribute_name {evaluation_item_id} -datatype {number}  -pretty_name {evaluation_item_id} -column_spec {integer}
content::type::attribute::new -content_type {evaluation_student_evals} -attribute_name {task_item_id} -datatype {number}  -pretty_name {task_item_id} -column_spec {integer}
content::type::attribute::new -content_type {evaluation_student_evals} -attribute_name {party_id} -datatype {number}  -pretty_name {party_id} -column_spec {integer}
content::type::attribute::new -content_type {evaluation_student_evals} -attribute_name {grade} -datatype {number}  -pretty_name {grade} -column_spec {numeric}
content::type::attribute::new -content_type {evaluation_student_evals} -attribute_name {show_student_p} -datatype {string}  -pretty_name {show_student_p} -column_spec {varchar(1)}
#evaluation_grades_sheets
content::type::attribute::new -content_type {evaluation_grades_sheets} -attribute_name {grades_sheet_item_id} -datatype {number}  -pretty_name {grades_sheet_item_id} -column_spec {integer}
content::type::attribute::new -content_type {evaluation_grades_sheets} -attribute_name {task_item_id} -datatype {number}  -pretty_name {task_item_id} -column_spec {integer}
}
}

ad_proc -public evaluation::apm::package_uninstall { 
} {

    Cleans the integration whith the notifications package.  

} {
    db_transaction {
        # Delete the type_id for a specific assignment
        notification::type::delete -short_name one_assignment_notif
	
        # Delete the implementation for the notification of an assignment
        delete_one_assignment_impl
	
        # Delete the type_id for a especific evaluation
        notification::type::delete -short_name one_evaluation_notif
	
        # Delete the implementation for the notification of an evaluation
	delete_one_evaluation_impl

#Delete content type template
set template_id [content::type::get_template -content_type {evaluation_tasks} -use_context {public}]
content::type::unregister_template -content_type {evaluation_tasks} -template_id $template_id -use_context {public}
content::template::delete -template_id $template_id
set template_id [content::type::get_template -content_type {evaluation_tasks_sols} -use_context {public}]
content::type::unregister_template -content_type {evaluation_tasks_sols} -template_id $template_id -use_context {public}
content::template::delete -template_id $template_id
set template_id [content::type::get_template -content_type {evaluation_answers} -use_context {public}]
content::type::unregister_template -content_type {evaluation_answers} -template_id $template_id -use_context {public}
content::template::delete -template_id $template_id
set template_id [content::type::get_template -content_type {evaluation_grades_sheets} -use_context {public}]
content::type::unregister_template -content_type {evaluation_grades_sheets} -template_id $template_id -use_context {public}
content::template::delete -template_id $template_id
#Delete content type attribute
content::type::attribute::delete -content_type {evaluation_grades} -attribute_name {grade_item_id}
content::type::attribute::delete -content_type {evaluation_grades} -attribute_name {grade_name} 
content::type::attribute::delete -content_type {evaluation_grades} -attribute_name {grade_plural_name} 
content::type::attribute::delete -content_type {evaluation_grades} -attribute_name {comments} 
content::type::attribute::delete -content_type {evaluation_grades} -attribute_name {weight} 
content::type::attribute::delete -content_type {evaluation_tasks} -attribute_name {task_item_id} 
content::type::attribute::delete -content_type {evaluation_tasks} -attribute_name {task_name} 
content::type::attribute::delete -content_type {evaluation_tasks} -attribute_name {number_of_members} 
content::type::attribute::delete -content_type {evaluation_tasks} -attribute_name {due_date} 
content::type::attribute::delete -content_type {evaluation_tasks} -attribute_name {grade_item_id} 
content::type::attribute::delete -content_type {evaluation_tasks} -attribute_name {weight} 
content::type::attribute::delete -content_type {evaluation_tasks} -attribute_name {online_p} 
content::type::attribute::delete -content_type {evaluation_tasks} -attribute_name {late_submit_p} 
content::type::attribute::delete -content_type {evaluation_tasks} -attribute_name {requires_grade_p} 
content::type::attribute::delete -content_type {evaluation_tasks_sols} -attribute_name {solution_item_id} 
content::type::attribute::delete -content_type {evaluation_tasks_sols} -attribute_name {task_item_id} 
content::type::attribute::delete -content_type {evaluation_answers} -attribute_name {answer_item_id} 
content::type::attribute::delete -content_type {evaluation_answers} -attribute_name {party_id} 
content::type::attribute::delete -content_type {evaluation_answers} -attribute_name {task_item_id} 
content::type::attribute::delete -content_type {evaluation_student_evals} -attribute_name {evaluation_item_id} 
content::type::attribute::delete -content_type {evaluation_student_evals} -attribute_name {task_item_id} 
content::type::attribute::delete -content_type {evaluation_student_evals} -attribute_name {party_id} 
content::type::attribute::delete -content_type {evaluation_student_evals} -attribute_name {grade} 
content::type::attribute::delete -content_type {evaluation_student_evals} -attribute_name {show_student_p}
content::type::attribute::delete -content_type {evaluation_grades_sheets} -attribute_name {grades_sheet_item_id}
content::type::attribute::delete -content_type {evaluation_grades_sheets} -attribute_name {task_item_id}                                                        
#Delete Content type
content::type::delete -content_type {evaluation_grades}
content::type::delete -content_type {evaluation_tasks}
content::type::delete -content_type {evaluation_tasks_sols}
content::type::delete -content_type {evaluation_answers}
content::type::delete -content_type {evaluation_student_evals}
content::type::delete -content_type {evaluation_grades_sheets}                                                                                            } 
}

ad_proc -public evaluation::apm::package_instantiate { 
    -package_id:required
} {

    Define Evaluation folders

} {

    set creation_user [ad_verify_and_get_user_id]
    set creation_ip [ad_conn peeraddr]
    
    create_folders -package_id $package_id
}


ad_proc -public evaluation::apm::package_uninstantiate { 
    -package_id:required
} {

    Delete Evaluation stuff

} {
  
    delete_contents -packagell folder and contents
}
