# /packages/evaluation/www/admin/evaluations/one-evaluation-edit.tcl

ad_page_contract {
    Page for editing evaluations

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    task_id:integer,notnull
    evaluation_id:integer,notnull
    {evaluation_mode "edit"}
} 

set return_url "student-list?[export_vars -url { task_id }]"

set page_title "View/Edit Evaluation"

set context [list [list [export_vars -base student-list { task_id }] "Students List"] $page_title]

if { [ad_form_new_p -key evaluation_id] || [string eq $evaluation_mode "display"] } {
	set comment_label "Comments"
} else {
	set comment_label "Edit Reason"
}

db_1row get_evaluation_info { *SQL* }
	
ad_form -name evaluation -cancel_url $return_url -export { task_id item_id party_id } -mode $evaluation_mode -form {

	evaluation_id:key

	{party_name:text  
		{label "Name"}
		{html {size 30}}
		{mode display}
	}
	
	{grade:text  
		{label "Grade"}
		{html {size 5}}
	}

	{comments:text(textarea)
		{label "$comment_label"}
		{html {rows 4 cols 40}}
	}

	{show_student_p:text(radio)     
		{label "Will the student be able to see the grade?"} 
		{options {{Yes t} {No f}}}
	}


} -edit_request {
	
	db_1row evaluation_info { *SQL* }
	set grade [format %.2f $grade]
	
} -validate {
	{grade 
		{ [ad_var_type_check_number_p $grade] }
		{ The grade must be a valid number } 
	}
	{comments
		{ [string length $comments] < 4000 }
		{ The edit reason must be less than 4000 characteras long  }
	}

} -on_submit {
	
	db_transaction {
		
		set revision_id [evaluation::new_evaluation -new_item_p 0 -item_id $item_id -content_type evaluation_student_evals \
							 -content_table evaluation_student_evals -content_id evaluation_id -description $comments \
							 -show_student_p $show_student_p -grade $grade -task_id $task_id -party_id $party_id]
		
		evaluation::set_live -revision_id $revision_id
		
	}

	# send the notification to everyone suscribed
	evaluation::notification::do_notification -task_id $task_id -evaluation_id $revision_id -package_id [ad_conn package_id] -notif_type one_evaluation_notif

 	ad_returnredirect "$return_url"
 	ad_script_abort
}

ad_return_template
