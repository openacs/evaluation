# /packages/evaluaiton/www/admin/evaluaitons/student-list.tcl

ad_page_contract {
    Displays the evaluations of students that have already been evaluated,
    lists the ones that have not been evaluated yet (in order to evaluate them)
    and deals with tasks in groups and individual.

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    task_id:integer,notnull
    {show_portrait_p ""}
    {return_url "[ad_conn url]?[export_vars -url { task_id }]"}
    {orderby_wa:optional}
    {orderby_na:optional}
    {orderby:optional}
} 

set user_id [ad_conn user_id]
set page_title "[_ evaluation.Student_List_]"
set context [list "[_ evaluation.Student_List_]"]

if { [string eq $show_portrait_p "t"] } {
    set this_url "student-list?[export_vars -entire_form -url { { show_portrait_p f } }]"
} else {
    set this_url "student-list?[export_vars -entire_form -url { { show_portrait_p t } }]"
}

db_1row get_task_info { *SQL* }
set due_date_pretty  [lc_time_fmt $due_date_ansi "%q"]

if { $number_of_members > 1 } {
    set groups_admin "<a href=[export_vars -base ../groups/one-task { task_id }]>[_ evaluation.lt_Groups_administration]</a>"
} else {
    set groups_admin ""
}

set done_students [list]
set evaluation_mode "display"

#
# working with already evaluated parties
#

set actions [list "[_ evaluation.Edit_Evaluations_]" [export_vars -base "evaluations-edit" { task_id }]]

set elements [list party_name \
		  [list label "[_ evaluation.Name_]" \
		       orderby_asc {party_name asc} \
		       orderby_desc {party_name desc} \
		       link_url_eval {[export_vars -base "one-evaluation-edit" { evaluation_id task_id evaluation_mode }]} \
		       link_html { title "[_ evaluation.View_evaluation_]" } \
		      ] \
		  grade \
		  [list label "[_ evaluation.Grade_over_100_]" \
		       orderby_asc {grade asc} \
		       orderby_desc {grade desc} \
		      ] \
		  action \
		  [list label "" \
		       display_template { @evaluated_students.action;noquote@ } \
		       link_url_col action_url \
		      ] \
		 ]

if { [string eq $online_p "t"] } {
    lappend elements submission_date_pretty \
	[list label "[_ evaluation.Submission_Date_]" \
	     display_template { @evaluated_students.submission_date_pretty;noquote@ } \
	     orderby_asc {submission_date_ansi asc} \
	     orderby_desc {submission_date_ansi desc}]
}

lappend elements view \
    [list label "" \
	 sub_class narrow \
	 display_template {<img src="/resources/acs-subsite/Zoom16.gif" width="16" height="16" border="0">} \
	 link_url_eval {[export_vars -base "one-evaluation-edit" { evaluation_id task_id evaluation_mode }]} \
	 link_html { title "[_ evaluation.View_evaluation_]" } \
	]
lappend elements edit \
    [list label "" \
	 sub_class narrow \
	 display_template {<img src="/resources/acs-subsite/Edit16.gif" width="16" height="16" border="0">} \
	 link_url_eval {[export_vars -base "one-evaluation-edit" { evaluation_id task_id }]} \
	 link_html { title "[_ evaluation.Edit_evaluation_]" } \
	] 
lappend elements delete \
    [list label {} \
	 sub_class narrow \
	 display_template {<img src="/resources/acs-subsite/Delete16.gif" width="16" height="16" border="0">} \
	 link_url_eval {[export_vars -base "evaluation-delete" { evaluation_id return_url task_id }]} \
	 link_html { title "[_ evaluation.Delete_evaluation_]" } \
	] 


template::list::create \
    -name evaluated_students \
    -multirow evaluated_students \
    -actions $actions \
    -key task_id \
    -pass_properties { return_url task_id evaluation_mode } \
    -filters { task_id {} } \
    -orderby { default_value party_name } \
    -elements $elements

set orderby [template::list::orderby_clause -orderby -name evaluated_students]

if {[string equal $orderby ""]} {
    set orderby " order by party_name asc"
} 

set total_evaluated 0
db_multirow -extend { action action_url submission_date_pretty } evaluated_students evaluated_students { *SQL* } {
    
    incr total_evaluated
    lappend done_students $party_id
    set grade [format %.2f [lc_numeric $grade]]
    
    if { [string eq $online_p "t"] } {
	if { [db_0or1row get_answer_info { *SQL* }] } {
	    # working with answer stuff (if it has a file/url attached)
	    if { [empty_string_p $answer_data] } {
		set action "[_ evaluation.No_response_]"
	    } elseif { [regexp "http://" $answer_data] } {
		set action_url "[export_vars -base "$answer_data" { }]"
		set action "[_ evaluation.View_answer_]"
	    } else {
		# we assume it's a file
		set action_url "[export_vars -base "../../view/$answer_title" { revision_id }]"
		set action "[_ evaluation.View_answer_]"
	    }
	    if { [string eq $action "[_ evaluation.View_answer_]"] && ([db_string compare_evaluation_date { *SQL* } -default 0] ) } {
		set action "<span style=\"color:red;\"> [_ evaluation.View_NEW_answer_]</span>"
	    }
	    set submission_date_pretty [lc_time_fmt $submission_date_ansi "%c"]
	    if { [db_string compare_submission_date { *SQL* } -default 0] } {
		set submission_date_pretty "[_ evaluation.lt_submission_date_prett]"
	    }
	} else {
	    set action "[_ evaluation.No_response_]"
	}
    }
} 

if { [llength $done_students] > 0 } {
    set processed_clause [db_map processed_clause]
} else {
    set processed_clause ""
}

set not_evaluated_with_answer 0

#
# working with students that have answered but have not been yet evaluated
#

set elements [list party_name \
		  [list label "[_ evaluation.Name_]" \
		       orderby_asc {party_name asc} \
		       orderby_desc {party_name desc} \
		       link_url_col party_url \
		      ] \
		 ]

if { [string eq $show_portrait_p "t"] && [string eq $number_of_members "1"] } {
    lappend elements portrait \
	[list label "[_ evaluation.Students_Portrait_]" \
	     display_template { @not_evaluated_wa.portrait;noquote@ }
	]
} 

lappend elements submission_date_pretty \
    [list label "[_ evaluation.Submission_Date_]" \
	 display_template { @not_evaluated_wa.submission_date_pretty;noquote@ } \
	 orderby_asc {submission_date_ansi asc} \
	 orderby_desc {submission_date_ansi desc}]
lappend elements answer \
    [list label "[_ evaluation.Answer_]" \
	 link_url_col answer_url \
	 link_html { title "[_ evaluation.View_answer_]" }] 
lappend elements grade \
    [list label "[_ evaluation.Maximun_Grade_] <input type=text name=\"max_grade\" maxlength=\"6\" size=\"3\" value=\"100\">" \
	 display_template { <input type=text name=grades_wa.@not_evaluated_wa.party_id@ maxlength=\"6\" size=\"3\"> } ] 
lappend elements comments \
    [list label "[_ evaluation.Comments_]" \
	 display_template { <textarea rows="3" cols="15" wrap name=comments_wa.@not_evaluated_wa.party_id@></textarea> } \
	] 
lappend elements show_answer \
    [list label "[_ evaluation.lt_Allow_the_students_br]" \
	 display_template { <pre>[_ evaluation.Yes_]<input checked type=radio name="show_student_wa.@not_evaluated_wa.party_id@" value=t> [_ evaluation.No_]<input type=radio name="show_student_wa.@not_evaluated_wa.party_id@" value=f></pre> } \
	] 

template::list::create \
    -name not_evaluated_wa \
    -multirow not_evaluated_wa \
    -key party_id \
    -pass_properties { task_id return_url } \
    -filters { task_id {} } \
    -orderby_name orderby_wa \
    -elements $elements 


set orderby_wa [template::list::orderby_clause -orderby -name not_evaluated_wa]

if { [string equal $orderby_wa ""] } {
    set orderby_wa " order by party_name asc"
}

db_multirow -extend { party_url answer answer_url submission_date_pretty portrait } not_evaluated_wa get_not_evaluated_wa_students { *SQL* } {
    
    incr not_evaluated_with_answer
    if { $number_of_members == 1 } {
	set tag_attributes [ns_set create]
	ns_set put $tag_attributes alt "[_ evaluation.lt_No_portrait_for_party]"
	ns_set put $tag_attributes width 98
	ns_set put $tag_attributes height 104
	set portrait "<a href=\"../grades/student-grades-report?[export_vars -url { { student_id $party_id } }]\">[evaluation::get_user_portrait -user_id $party_id -tag_attributes]</a>"
    } else {
	set party_url "../groups/one-task?[export_vars -url { task_id return_url }]#groups"
    }

    lappend done_students $party_id
    if { [string eq $online_p "t"] } {
	set submission_date_pretty  "[lc_time_fmt $submission_date_ansi "%Q"] [lc_time_fmt $submission_date_ansi "%X"]"
	if { [db_string compare_submission_date { *SQL* } -default 0] } {
	    set submission_date_pretty "[_ evaluation.lt_submission_date_prett_1]"
	} else {
	}
	set answer "[_ evaluation.View_answer_]"
	# working with answer stuff (if it has a file/url attached)
	if { [regexp "http://" $answer_data] } {
	    set answer_url [export_vars -base "$answer_data" { }]
	} else {
	    # we assume it's a file
	    set answer_url [export_vars -base "../../view/$answer_title" { revision_id }]
	}
    } 
}

#
# working with students that have not answered and have not been yet evaluated and do not have submited their answers
#

set elements [list party_name \
		  [list label "[_ evaluation.Name_]" \
		       orderby_asc {party_name asc} \
		       orderby_desc {party_name desc} \
		       link_url_col party_url \
		      ] \
		 ]

if { [string eq $show_portrait_p "t"] && [string eq $number_of_members "1"] } {
    lappend elements portrait \
	[list label "[_ evaluation.Students_Portrait_]" \
	     display_template { @not_evaluated_na.portrait;noquote@ }
	]
} 

lappend elements grade \
    [list label "[_ evaluation.Grade_over_] <input type=text name=\"max_grade\" maxlength=\"6\" size=\"3\" value=\"100\">" \
	 display_template { <input type=text name=grades_na.@not_evaluated_na.party_id@ maxlength=\"6\" size=\"3\"> } ]
lappend elements comments \
    [list label "[_ evaluation.Comments_]" \
	 display_template { <textarea rows="3" cols="15" wrap name=comments_na.@not_evaluated_na.party_id@></textarea> } \
	]
lappend elements show_answer \
    [list label "[_ evaluation.lt_Allow_the_students_br]" \
	 display_template { <pre>[_ evaluation.Yes_]<input checked type=radio name="show_student_na.@not_evaluated_na.party_id@" value=t> [_ evaluation.No_]<input type=radio name="show_student_na.@not_evaluated_na.party_id@" value=f></pre> } \
	]

template::list::create \
    -name not_evaluated_na \
    -multirow not_evaluated_na \
    -key party_id \
    -pass_properties { task_id return_url } \
    -filters { task_id {} } \
    -orderby_name orderby_na \
    -elements $elements 

set orderby_na [template::list::orderby_clause -orderby -name not_evaluated_na]

if { [string equal $orderby_na ""] } {
    set orderby_na " order by party_name asc"
}

if { $number_of_members > 1 } {
    if { [llength $done_students] > 0 } {
	set not_in_clause [db_map not_in_clause]
    } else {
	set not_in_clause ""
    }
    set sql_query [db_map sql_query_groups]
} else {
    set community_id [dotlrn_community::get_community_id]
    if { [llength $done_students] > 0 } {
	set not_in_clause [db_map not_yet_in_clause]
    } else {
	set not_in_clause ", cc_users cu 
                           where p.person_id = cu.person_id 
                             and cu.member_state = 'approved'"
    }

    # if this page is called from within a community (dotlrn) we have to show only the students

    if { [empty_string_p $community_id] } {
	set sql_query [db_map sql_query_individual]
    } else {
	set sql_query [db_map sql_query_community_individual]
    }

}

set not_evaluated_with_no_answer 0

db_multirow -extend { party_url portrait } not_evaluated_na get_not_evaluated_na_students { *SQL* } {
    
    incr not_evaluated_with_no_answer
    if { $number_of_members == 1 } {
	set tag_attributes [ns_set create]
	ns_set put $tag_attributes alt "[_ evaluation.lt_No_portrait_for_party]"
	ns_set put $tag_attributes width 98
	ns_set put $tag_attributes height 104
	set portrait "<a href=\"../grades/student-grades-report?[export_vars -url { { student_id $party_id } }]\">[evaluation::get_user_portrait -user_id $party_id -tag_attributes $tag_attributes]</a>"
    } else {
	set party_url "../groups/one-task?[export_vars -url { task_id return_url }]#groups"
    }
}

set grades_sheet_item_id [db_nextval acs_object_id_seq]




