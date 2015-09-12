# /packages/evaluation/www/evaluationk-view.tcl

ad_page_contract {
    Page for viewing evaluations.

    @author jopez@galileo.edu
    @creation-date Sept 2004
    @cvs-id $Id$
} {
    evaluation_id:naturalnum,notnull
    {return_url ""}
}

set page_title "[_ evaluation.View_Evaluation]"
set context [list $page_title]
set user_id [ad_conn user_id]

if { ![db_0or1row get_evaluation_info { *SQL* }] } {
	ad_return_complaint 1 "Evaluation does not exist"
	return
}

ad_form -name evaluation -has_submit 1 -has_edit 1 -mode display -form {

    evaluation_id:key

    {task_name:text  
	{label "[_ evaluation.Task_Name_1]"}
	{html {size 30}}
	{value $task_name}
    }
    
}

set answer_data ""
db_0or1row get_answer_info { *SQL* }

set due_date [template::util::date::from_ansi $due_date_ansi]
set evaluation_date [template::util::date::from_ansi $evaluation_date_ansi]
set task_weight [lc_numeric %.2f $task_weight]
set grade_weight [lc_numeric %.2f $grade_weight]
set net_grade [lc_numeric %.2f $net_grade]

if { $answer_data ne "" } {
    
    if {$answer_title eq "link"} {
 	set answer_url "<a href=\"$answer_data\">$answer_data</a>"
    } else {
	# we assume it's a file
 	set answer_url "<a href=\"[export_vars -base "view/$answer_title" -url { {revision_id $answer_revision_id} }]\">$answer_title</a>"
    }
    set answer_date [template::util::date::from_ansi $submission_date_ansi]

    ad_form -extend -name evaluation -form {			
	{task_file:text,optional
	    {label "[_ evaluation.Answer]"} 
	    {html "size 30"}
	    {after_html "$answer_url"}
      }
	{answer_owner:text,optional  
	    {label "[_ evaluation.Submitted_by]"}
	    {value $answer_owner}
	}     
	{answer_date:date,to_sql(linear_date),from_sql(sql_date)
	    {label "[_ evaluation.Answer_Date]"}
	    {format "MONTH DD YYYY HH24 MI SS"}
	    {today}
	    {help}
	    {value $answer_date}
	}
    }
}

if { $number_of_members > 1 } {
    db_1row get_group_info { *SQL* }
    ad_form -extend -name evaluation -form {			
	{group_name:text,optional
	    {label "[_ evaluation.Group_Name]"} 
	    {value $group_name}
	}
    }
    set members [list]
    db_foreach group_members { *SQL* } {
	lappend members [list "$member_name" {}]
    }
    ad_form -extend -name evaluation -form {			
	{group_members:text(radio),optional
	    {label "[_ evaluation.Group_Members]"} 
	    {options $members}
	}
    }
	
}

ad_form -extend -name evaluation -form {

    {grade:text,optional  
	{label "[_ evaluation.Grade_2]"}
	{value $grade}
    }
    {task_weight:text  
	{label "[_ evaluation.lt_Weight_of_this_grade_]"}
	{value ${task_weight}%}
    }
    {grade_weight:text
	{label "[_ evaluation.lt_Weight_of_grade_plura]"}
	{value ${grade_weight}%}
    }
    {net_grade:text,optional  
	{label "[_ evaluation.Net_Grade]"}
	{value $net_grade}
    }
    {grader:text,optional  
	{label "[_ evaluation.Grader]"}
	{value $grader}
    }
    {comments:text(textarea)
	{label "[_ evaluation.Comments_1]"}
	{html {rows 4 cols 40}}
	{value $comments}
    }
    {evaluation_date:date,to_sql(linear_date),from_sql(sql_date)
	{label "[_ evaluation.Evaluation_Date]"}
	{format "MONTH DD YYYY HH24 MI SS"}
	{today}
	{help}
	{value $evaluation_date}
    }

    {due_date:date,to_sql(linear_date),from_sql(sql_date)
	{label "[_ evaluation.lt_Due_Date_of_task_name]"}
	{format "MONTH DD YYYY HH24 MI SS"}
	{today}
	{help}
	{value $due_date}
    }
}

ad_return_template



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
