# /packages/evaluation/tcl/apm-callback-procs.tcl

ad_library {

    Evaluations Package APM callbacks library
    
    Procedures that deal with installing, instantiating, mounting.

    @creation-date Apr 2004
    @author jopez@galileo.edu
    @cvs-id $Id$
}

namespace eval evaluation {}
namespace eval evaluation::apm_callback {}


ad_proc -public evaluation::apm_callback::package_install {  
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

	#Create the conten types
	content::type::new -content_type evaluation_grades -supertype content_revision -pretty_name "Evaluation Grade" -pretty_plural "Evaluation Grades" -table_name evaluation_grades -id_column grade_id
	content::type::new -content_type evaluation_tasks -supertype content_revision -pretty_name "Evaluation Task" -pretty_plural "Evaluation Tasks" -table_name evaluation_tasks -id_column task_id
	content::type::new -content_type evaluation_tasks_sols -supertype content_revision -pretty_name "Evaluation Task Solution" -pretty_plural "Evaluation Tasks Solutions" -table_name evaluation_tasks_sols -id_column solution_id
	content::type::new -content_type evaluation_answers -supertype content_revision -pretty_name "Student Answer" -pretty_plural "Student Answers" -table_name evaluation_answers -id_column answer_id
	content::type::new -content_type evaluation_student_evals -supertype content_revision -pretty_name "Student Evaluation" -pretty_plural "Student Evaluations" -table_name evaluation_student_evals -id_column evaluation_id
	content::type::new -content_type evaluation_grades_sheets -supertype content_revision -pretty_name "Evaluation Grades Sheet" -pretty_plural "Evaluation Grades Sheets" -table_name evaluation_grades_sheets -id_column grades_sheet_id

	#Create and register the templates
	set template_id [content::template::new -name evaluation-tasks-default -text "@text;noquote@" -is_live t]
	content::type::register_template -content_type evaluation_tasks -template_id $template_id -use_context public -is_default t
	set template_id [content::template::new -name evaluation-tasks-sols-default -text "@text;noquote@" -is_live t]
	content::type::register_template -content_type evaluation_tasks_sols -template_id $template_id -use_context public -is_default t
	set template_id [content::template::new -name evaluation-answers-default -text "@text;noquote@" -is_live t]
	content::type::register_template -content_type evaluation_answers -template_id $template_id -use_context public -is_default t
	set template_id [content::template::new -name evaluation-grades-sheets-default -text "@text;noquote@" -is_live t]
	content::type::register_template -content_type evaluation_grades_sheets -template_id $template_id -use_context public -is_default t

	#Create content type attributes for content type evaluation_grades
	content::type::attribute::new -content_type evaluation_grades -attribute_name grade_item_id -datatype number -pretty_name grade_item_id -column_spec integer
	content::type::attribute::new -content_type evaluation_grades -attribute_name grade_name -datatype string -pretty_name grade_name -column_spec "varchar(100)"
	content::type::attribute::new -content_type evaluation_grades -attribute_name grade_plural_name -datatype string -pretty_name grade_plural_name -column_spec "varchar(100)"
	content::type::attribute::new -content_type evaluation_grades -attribute_name comments -datatype string -pretty_name Comments -column_spec "varchar(500)"
	content::type::attribute::new -content_type evaluation_grades -attribute_name weight -datatype number -pretty_name Weight -column_spec numeric

	#Create content type attributes for content type evaluation_tasks
	content::type::attribute::new -content_type evaluation_tasks -attribute_name task_item_id -datatype number -pretty_name task_item_id -column_spec integer
	content::type::attribute::new -content_type evaluation_tasks -attribute_name task_name -datatype number -pretty_name task_name -column_spec integer
	content::type::attribute::new -content_type evaluation_tasks -attribute_name number_of_members -datatype string -pretty_name number_of_members -column_spec varchar
	content::type::attribute::new -content_type evaluation_tasks -attribute_name due_date -datatype number -pretty_name due_date -column_spec timestamptz
	content::type::attribute::new -content_type evaluation_tasks -attribute_name grade_item_id -datatype number -pretty_name grade_item_id -column_spec integer
	content::type::attribute::new -content_type evaluation_tasks -attribute_name weight -datatype number -pretty_name weight -column_spec numeric
	content::type::attribute::new -content_type evaluation_tasks -attribute_name online_p -datatype string -pretty_name online_p -column_spec "varchar(1)"
	content::type::attribute::new -content_type evaluation_tasks -attribute_name late_submit_p -datatype string -pretty_name late_submit_p -column_spec "varchar(1)"
	content::type::attribute::new -content_type evaluation_tasks -attribute_name requires_grade_p -datatype string -pretty_name requires_grade_p -column_spec "varchar(1)"

	#Create content type attributes for content type evaluation_tasks_sols
	content::type::attribute::new -content_type evaluation_tasks_sols -attribute_name solution_item_id -datatype number -pretty_name solution_item_id -column_spec integer
	content::type::attribute::new -content_type evaluation_tasks_sols -attribute_name task_item_id -datatype number -pretty_name task_item_id -column_spec integer

	#Create content type attributes for content type evaluation_answers
	content::type::attribute::new -content_type evaluation_answers -attribute_name answer_item_id -datatype number -pretty_name answer_item_id -column_spec integer
	content::type::attribute::new -content_type evaluation_answers -attribute_name party_id -datatype number -pretty_name party_id -column_spec integer
	content::type::attribute::new -content_type evaluation_answers -attribute_name task_item_id -datatype number -pretty_name task_item_id -column_spec integer

	#Create content type attributes for content type evaluation_student_evals
	content::type::attribute::new -content_type evaluation_student_evals -attribute_name evaluation_item_id -datatype number -pretty_name evaluation_item_id -column_spec integer
	content::type::attribute::new -content_type evaluation_student_evals -attribute_name task_item_id -datatype number -pretty_name task_item_id -column_spec integer
	content::type::attribute::new -content_type evaluation_student_evals -attribute_name party_id -datatype number -pretty_name party_id -column_spec integer
	content::type::attribute::new -content_type evaluation_student_evals -attribute_name grade -datatype number -pretty_name grade -column_spec numeric
	content::type::attribute::new -content_type evaluation_student_evals -attribute_name show_student_p -datatype string -pretty_name show_student_p -column_spec "varchar(1)"

	#Create content type attributes for content type evaluation_grades_sheets
	content::type::attribute::new -content_type evaluation_grades_sheets -attribute_name grades_sheet_item_id -datatype number -pretty_name grades_sheet_item_id -column_spec integer
	content::type::attribute::new -content_type evaluation_grades_sheets -attribute_name task_item_id -datatype number -pretty_name task_item_id -column_spec integer

    }
}

ad_proc -public evaluation::apm_callback::package_uninstall { 
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

	#Delete content type templates
	set template_id [content::type::get_template -content_type evaluation_tasks -use_context public]
	content::type::unregister_template -content_type evaluation_tasks -template_id $template_id -use_context public
	content::template::delete -template_id $template_id
	set template_id [content::type::get_template -content_type evaluation_tasks_sols -use_context public]
	content::type::unregister_template -content_type evaluation_tasks_sols -template_id $template_id -use_context public
	content::template::delete -template_id $template_id
	set template_id [content::type::get_template -content_type evaluation_answers -use_context public]
	content::type::unregister_template -content_type evaluation_answers -template_id $template_id -use_context public
	content::template::delete -template_id $template_id
	set template_id [content::type::get_template -content_type evaluation_grades_sheets -use_context public]
	content::type::unregister_template -content_type evaluation_grades_sheets -template_id $template_id -use_context public
	content::template::delete -template_id $template_id

	#Delete content type attributes
	content::type::attribute::delete -content_type evaluation_grades -attribute_name grade_item_id
	content::type::attribute::delete -content_type evaluation_grades -attribute_name grade_name 
	content::type::attribute::delete -content_type evaluation_grades -attribute_name grade_plural_name 
	content::type::attribute::delete -content_type evaluation_grades -attribute_name comments 
	content::type::attribute::delete -content_type evaluation_grades -attribute_name weight 
	content::type::attribute::delete -content_type evaluation_tasks -attribute_name task_item_id 
	content::type::attribute::delete -content_type evaluation_tasks -attribute_name task_name 
	content::type::attribute::delete -content_type evaluation_tasks -attribute_name number_of_members 
	content::type::attribute::delete -content_type evaluation_tasks -attribute_name due_date 
	content::type::attribute::delete -content_type evaluation_tasks -attribute_name grade_item_id 
	content::type::attribute::delete -content_type evaluation_tasks -attribute_name weight 
	content::type::attribute::delete -content_type evaluation_tasks -attribute_name online_p 
	content::type::attribute::delete -content_type evaluation_tasks -attribute_name late_submit_p 
	content::type::attribute::delete -content_type evaluation_tasks -attribute_name requires_grade_p 
	content::type::attribute::delete -content_type evaluation_tasks_sols -attribute_name solution_item_id 
	content::type::attribute::delete -content_type evaluation_tasks_sols -attribute_name task_item_id 
	content::type::attribute::delete -content_type evaluation_answers -attribute_name answer_item_id 
	content::type::attribute::delete -content_type evaluation_answers -attribute_name party_id 
	content::type::attribute::delete -content_type evaluation_answers -attribute_name task_item_id 
	content::type::attribute::delete -content_type evaluation_student_evals -attribute_name evaluation_item_id 
	content::type::attribute::delete -content_type evaluation_student_evals -attribute_name task_item_id 
	content::type::attribute::delete -content_type evaluation_student_evals -attribute_name party_id 
	content::type::attribute::delete -content_type evaluation_student_evals -attribute_name grade 
	content::type::attribute::delete -content_type evaluation_student_evals -attribute_name show_student_p
	content::type::attribute::delete -content_type evaluation_grades_sheets -attribute_name grades_sheet_item_id
	content::type::attribute::delete -content_type evaluation_grades_sheets -attribute_name task_item_id                                                        
	#Delete Content types
	content::type::delete -content_type evaluation_grades
	content::type::delete -content_type evaluation_tasks
	content::type::delete -content_type evaluation_tasks_sols
	content::type::delete -content_type evaluation_answers
	content::type::delete -content_type evaluation_student_evals
	content::type::delete -content_type evaluation_grades_sheets                                                                                            
    } 
}

ad_proc -public evaluation::apm_callback::package_instantiate { 
    -package_id:required
} {

    Define Evaluation folders

} {

    set creation_user [ad_conn user_id]
    set creation_ip [ad_conn peeraddr]
    set exams_name "[_ evaluation.Exams_]"
    set exams_singular_name "[_ evaluation.Exam]"
    set exams_desc "[_ evaluation.Exams_for_students_]"
    set tasks_name "[_ evaluation.Tasks_]"
    set tasks_singular_name "[_ evaluation.Task]"
    set tasks_desc "[_ evaluation.Tasks_for_students_]"
    set projects_name "[_ evaluation.Projects_]"
    set projects_singular_name "[_ evaluation.Project]"
    set projects_desc "[_ evaluation.lt_Projects_for_students]"

    db_transaction {
	set folder_id [content::folder::new -name "evaluation_grades_$package_id" -label "evaluation_grades_$package_id" -package_id $package_id ]
	content::folder::register_content_type -folder_id $folder_id -content_type evaluation_grades -include_subtypes t

	set folder_id [content::folder::new -name "evaluation_tasks_$package_id" -label "evaluation_tasks_$package_id" -package_id $package_id ]
	content::folder::register_content_type -folder_id $folder_id -content_type evaluation_tasks -include_subtypes t
	
	set folder_id [content::folder::new -name "evaluation_tasks_sols_$package_id" -label "evaluation_tasks_sols_$package_id" -package_id $package_id ]
	content::folder::register_content_type -folder_id $folder_id -content_type evaluation_tasks_sols -include_subtypes t

	set folder_id [content::folder::new -name "evaluation_answers_$package_id" -label "evaluation_answers_$package_id" -package_id $package_id ]
	content::folder::register_content_type -folder_id $folder_id -content_type evaluation_answers -include_subtypes t
	
	set folder_id [content::folder::new -name "evaluation_grades_sheets_$package_id" -label "evaluation_grades_sheets_$package_id" -package_id $package_id ]
	content::folder::register_content_type -folder_id $folder_id -content_type evaluation_grades_sheets -include_subtypes t
	
	set folder_id [content::folder::new -name "evaluation_student_evals_$package_id" -label "evaluation_student_evals_$package_id" -package_id $package_id ]
	content::folder::register_content_type -folder_id $folder_id -content_type evaluation_student_evals -include_subtypes t  
    }

    set exams_item_id [db_nextval acs_object_id_seq]
    set revision_id [evaluation::new_grade -new_item_p 1 -item_id $exams_item_id -content_type evaluation_grades -content_table evaluation_grades -content_id grade_id -name $exams_singular_name -plural_name $exams_name -description $exams_desc -weight 40 -package_id $package_id]
    content::item::set_live_revision -revision_id $revision_id

    set tasks_item_id [db_nextval acs_object_id_seq]
    set revision_id [evaluation::new_grade -new_item_p 1 -item_id $tasks_item_id -content_type evaluation_grades -content_table evaluation_grades -content_id grade_id -name $tasks_singular_name -plural_name $tasks_name -description $tasks_desc -weight 40 -package_id $package_id]
    content::item::set_live_revision -revision_id $revision_id

    set projects_item_id [db_nextval acs_object_id_seq]
    set revision_id [evaluation::new_grade -new_item_p 1 -item_id $projects_item_id -content_type evaluation_grades -content_table evaluation_grades -content_id grade_id -name $projects_singular_name -plural_name $projects_name -description $projects_desc -weight 20 -package_id $package_id]
    content::item::set_live_revision -revision_id $revision_id   
}


ad_proc -public evaluation::apm_callback::package_uninstantiate { 
    -package_id:required
} {

    Delete Evaluation stuff

} {
    #Delete all content templates
    db_foreach answer { 
	select ea.answer_id from evaluation_answersi ea, acs_objects ao where ea.item_id = ao.object_id and ao.context_id = p_package_id 
    } {
	content::revision::delete -revision_id $answer_id
    }
    
    db_foreach solution { 
	select ets.solution_id from evaluation_tasks_solsi ets, acs_objects ao where ets.item_id = ao.object_id and ao.context_id = p_package_id  
    } { 
	content::revision::delete -revision_id $solution_id 
    }
    
    db_foreach grades_sheet { 
	select egs.grades_sheet_id from evaluation_grades_sheetsi egs, acs_objects ao where egs.item_id = ao.object_id and ao.context_id = p_package_id  
    } {
	content::revision::delete -revision_id $grades_sheet_id 
    }

    db_foreach student_eval { 
	select ese.evaluation_id from evaluation_student_evalsi ese, acs_objects ao where ese.item_id = ao.object_id and ao.context_id = p_package_id  
    } {
	content::revision::delete -revision_id $evaluation_id 
    }
    
    db_foreach evaluation_task { 
	select et.task_id from evaluation_tasksi et, acs_objects ao where et.item_id = ao.object_id and ao.context_id = p_package_id  
    } {
	content::revision::delete -revision_id $task_id 
    }

    db_foreach evaluation_grade { 
	select eg.grade_id from evaluation_gradesi eg, acs_objects ao where eg.item_id = ao.object_id and ao.context_id = p_package_id  
    } {
	content::revision::delete -revision_id $grade_id
    }

    #evaluation_task_sols
    set folder_id [content::item::get_id -item_path "evaluation_tasks_sols_$package_id" -resolve_index f]
    db_foreach task_sol_item { 
	select item_id from cr_items where  parent_id = :folder_id 
    } {
        evaluation::item::delete -item_id $item_id
    }
    content::folder::unregister_content_type -folder_id $folder_id  -content_type content_revision -include_subtypes t
    content::folder::unregister_content_type -folder_id $folder_id  -content_type evaluation_tasks_sols -include_subtypes t

    db_dml delete_task_sols_folder_map "delete from cr_folder_type_map where content_type = 'evaluation_tasks_sols'"
    content::folder::delete -folder_id $folder_id
    
    #evaluation_answers
    set folder_id [content::item::get_id -item_path "evaluation_answers_$package_id" -resolve_index f]

    db_foreach answer_item {
	select item_id from cr_items where  parent_id = :folder_id 
    } {
	    content::item::delete -item_id $item_id 
    }

    content::folder::unregister_content_type -folder_id $v_folder_id -content_type content_revision -include_subtypes t
    content::folder::unregister_content_type -folder_id $v_folder_id -content_type evaluation_answers -include_subtypes t
    db_dml delete_answer_folder_map "delete from cr_folder_type_map where content_type = 'evaluation_answers'"
    content::folder::delete -folder_id $folder_id

    #evaluation_students_eval
    set folder_id [content::item::get_id -item_path "evaluation_student_evals_$package_id" -resolve_index f]

    db_foreach student_eval_item { 
	select item_id from cr_items where  parent_id = :folder_id 
    } {
	evaluation::delete_student_eval -evaluation_id $item_id 
    }

    content::folder::unregister_content_type -folder_id $folder_id -content_type content_revision -include_subtypes t
    content::folder::unregister_content_type -folder_id $folder_id -content_type evaluation_student_evals -include_subtypes t

    db_dml delete_student_eval_folder_map "delete from cr_folder_type_map where content_type = 'evaluation_student_evals'"
    content::folder::delete -folder_id $folder_id
    
    #evaluation_grades_sheets
    set folder_id [content::item::get_id -item_path "evaluation_grades_sheets_$package_id" -resolve_index f]

    db_foreach grade_sheet_item { 
	select item_id  from cr_items where  parent_id = :folder_id 
    } {
	content::delete::item -item_id $item_id 
    }

    content::folder::unregister_content_type -folder_id $folder_id -content_type content_revision -include_subtypes t
    content::folder::unregister_content_type -folder_id $folder_ied -content_type evaluation_grades_sheets -include_subtypes t

    db_dml delete_grade_sheet_folder_map "delete from cr_folder_type_map where content_type = 'evaluation_grades_sheets'"
    content::folder::delete -folder_id $folder_id
    
    #evaluation_tasks
    set folder_id [content::item::get_id -item_path "evaluation_tasks_$package_id" -resolve_index f]

    db_foreach task_item { 
	select cri.revision_id as task_id
	from cr_revisions cri, cr_items cr
	where cr.item_id = cri.item_id
	and cr.parent_id = :folder_id
    } {
	evaluation::delete_task -task_id $item_id 
    }

    content::folder::unregister_content_type -folder_id $v_folder_id -content_type content_revision -include_subtypes t
    content::folder::unregister_content_type -folder_id $v_folder_id -content_type evaluation_tasks -include_subtypes t

    db_dml delete_tasks_folder_map "delete from cr_folder_type_map where content_type = 'evaluation_tasks'"
    content::folder::delete -folder_id $folder_id

    #evaluation_grades
    set folder_id [content::item::get_id -item_path "evaluation_grades_$package_id" -resolve_index f]

    db_foreach grade_item { 
	select cri.revision_id as grade_id
	from cr_revisions cri, cr_items cr
	where cr.item_id = cri.item_id
	and cr.parent_id = :folder_id
    } {
	evaluation::delete_grade -grade_id $grade_id 
    }

    content::folder::unregister_content_type -folder_id $v_folder_id -content_type content_revision -include_subtypes t
    content::folder::unregister_content_type -folder_id $v_folder_id -content_type evaluation_grades -include_subtypes t

    db_dml delete_grade_folder_map "delete from cr_folder_type_map where content_type = 'evaluation_grades'"
    content::folder::delete -folder_id $folder_id 
}
