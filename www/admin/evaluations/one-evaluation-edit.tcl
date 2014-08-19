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

set page_title "[_ evaluation.ViewEdit_Evaluation_]"

set context [list [list [export_vars -base student-list { task_id }] "[_ evaluation.Students_List_]"] $page_title]

if { [ad_form_new_p -key evaluation_id] || $evaluation_mode eq "display" } {
	set comment_label "[_ evaluation.Comments_]"
} else {
	set comment_label "[_ evaluation.Edit_Reason_]"
}

db_1row get_evaluation_info { *SQL* }
	
ad_form -name evaluation -cancel_url $return_url -export { task_id item_id party_id } -mode $evaluation_mode -form {

	evaluation_id:key

	{party_name:text  
		{label "[_ evaluation.Name_]"}
		{html {size 30}}
		{mode display}
	}
	
	{grade:text  
		{label "[_ evaluation.Grade_]"}
		{html {size 5}}
	}

	{comments:text(textarea)
		{label "$comment_label"}
		{html {rows 4 cols 40}}
	}

	{show_student_p:text(radio)     
		{label "[_ evaluation.lt_Will_the_student_be_a_1]"} 
		{options {{"[_ evaluation.Yes_]" t} {"[_ evaluation.No_]" f}}}
	}


} -edit_request {
	
	db_1row evaluation_info { *SQL* }
	set grade [lc_numeric $grade]
	
} -validate {
	{grade 
		{ [ad_var_type_check_number_p $grade] }
		{ [_ evaluation.lt_The_grade_must_be_a_v_1] } 
	}
	{comments
		{ [string length $comments] < 4000 }
		{ [_ evaluation.lt_The_edit_reason_must_] }
	}

} -on_submit {
	
    db_transaction {
	
		set revision_id [evaluation::new_evaluation -new_item_p 0 -item_id $item_id -content_type evaluation_student_evals \
							 -content_table evaluation_student_evals -content_id evaluation_id -description $comments \
							 -show_student_p $show_student_p -grade $grade -task_item_id $task_item_id -party_id $party_id]
		
		content::item::set_live_revision -revision_id $revision_id
		
    }
    
    # send the notification to everyone suscribed
    evaluation::notification::do_notification -task_id $task_id -evaluation_id $revision_id -package_id [ad_conn package_id] -notif_type one_evaluation_notif -subset [list $party_id]
    
    ad_returnredirect "$return_url"
    ad_script_abort
}
	    
ad_return_template
