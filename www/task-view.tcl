# /packages/evaluation/www/task-view.tcl

ad_page_contract {
    Page for viewing tasks.

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    grade_id:integer,notnull
    task_id:integer,notnull
    {return_url ""}
}

set package_id [ad_conn package_id]
set page_title "[_ evaluation.View_Task_]"

db_1row get_grade_info { *SQL* }

set context [list $page_title]

db_1row get_task_info { *SQL* }

ad_form -name task -has_submit 1 -has_edit 1 -export { return_url item_id storage_type grade_id attached_p } -mode display -form {

    task_id:key

    {task_name:text  
	{label "[_ evaluation.Task_Name_]"}
	{html {size 30}}
    }
    
}
db_1row get_task_info { *SQL* }

if { ![empty_string_p $task_data] } {

    if { [regexp "http://" $task_data] } {
 	set task_url "<a href=\"$task_data\">$task_data</a>"
    } else {
	# we assume it's a file
 	set task_url "<a href=\"[export_vars -base "view/$task_title" -url { {revision_id $task_revision_id} }]\">$task_title</a>"
    }
    
    ad_form -extend -name task -form {			
	{task_file:text,optional
	    {label "[_ evaluation.lt_Assignment_Attachment]"} 
	    {html "size 30"}
	    {after_html "$task_url"}
	}
    }
}

if { ![empty_string_p $solution_data] } {

    if { [regexp "http://" $solution_data] } {
 	set solution_url "<a href=\"$solution_data\">$solution_data</a>"
    } else {
	# we assume it's a file
 	set solution_url "<a href=\"[export_vars -base "view/$solution_title" -url { {revision_id $solution_revision_id} }]\">$solution_title</a>"
    }
    
    ad_form -extend -name task -form {			
	{solution_file:text,optional
	    {label "[_ evaluation.Solution_Attachment_]"} 
	    {html "size 30"}
	    {after_html "$solution_url"}
	}
    }
}

ad_form -extend -name task -form {

    {description:richtext,optional  
	{label "[_ evaluation.lt_Assignments_Descripti]"}
	{html {rows 4 cols 40 wrap soft}}
    }

    {due_date:date,to_sql(linear_date),from_sql(sql_date)
	{label "[_ evaluation.Due_Date_]"}
	{format "MONTH DD YYYY"}
	{today}
	{help}
	{value {[evaluation::now_plus_days -ndays 15]}}
    }

    {number_of_members:naturalnum
	{label "[_ evaluation.Number_of_Members_]"}
	{value "1"}
	{html {size 5 onChange TaskInGroups()}}
	{help_text "[_ evaluation.1__Individual_]"}
    }

    {weight:float  
	{label "[_ evaluation.Weight_]"}
	{html {size 5}}
	{help_text "[_ evaluation.lt_over_grade_weight_of_]"}
    }
    
    {online_p:text(radio)     
	{label "[_ evaluation.lt_Will_the_task_be_subm]"} 
	{options {{"[_ evaluation.Yes_]" t} {"[_ evaluation.No_]" f}}}
	{value t}
    }

    {late_submit_p:text(radio)     
	{label "[_ evaluation.lt_Can_the_student_submi]"} 
	{options {{"[_ evaluation.Yes_]" t} {"[_ evaluation.No_]" f}}}
	{value t}
    }

    {requires_grade_p:text(radio)     
	{label "[_ evaluation.lt_Will_this_task_requir]"} 
	{options {{"[_ evaluation.Yes_]" t} {"[_ evaluation.No_]" f}}}
	{value t}
    }
} -edit_request {
    
    db_1row task_info { *SQL* }

    set due_date [template::util::date::from_ansi $due_date_ansi]
    set weight [format %.2f [lc_numeric $weight]]

}

ad_return_template

