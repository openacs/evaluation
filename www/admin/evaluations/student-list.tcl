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
	{return_url "student-list?[export_vars -url { task_id }]"}
	{orderby_wa:optional}
	{orderby_na:optional}
} 

set user_id [ad_conn user_id]

set page_title "Student List"
set context { "Student List" }

db_1row get_task_info { *SQL* }

if { $number_of_members > 1 } {
	set groups_admin "<a href=[export_vars -base ../groups/one-task { task_id }]>Groups administration</a>"
} else {
	set groups_admin ""
}

set done_students [list]
set evaluation_mode "display"

#
# working with already evaluated parties
#

set actions [list "Edit Evaluations" [export_vars -base "evaluations-edit" { task_id }]]

template::list::create \
    -name evaluated_students \
    -multirow evaluated_students \
    -actions $actions \
    -key task_id \
    -pass_properties { return_url task_id evaluation_mode } \
    -filters { task_id {} } \
    -elements {
        party_name {
            label "Name"
	    orderby_asc {party_name asc}
	    orderby_desc {party_name desc}
            link_url_eval {[export_vars -base "one-evaluation-edit" { evaluation_id task_id evaluation_mode }]}
            link_html { title "View evaluation" }
        }
        grade {
            label "Maximun Grade: 100"
	    orderby_asc {grade asc}
	    orderby_desc {grade desc}
        }
        actions {
            label ""
	    link_url_col actions_url
        }
        pretty_submission_date {
            label "Sumission Date"
	    orderby_asc {pretty_submission_date asc}
	    orderby_desc {pretty_submission_date desc}
        }
        view {
            label {}
            sub_class narrow
            display_template {
                <img src="/resources/acs-subsite/Zoom16.gif" width="16" height="16" border="0">
            } 
            link_url_eval {[export_vars -base "one-evaluation-edit" { evaluation_id task_id evaluation_mode }]}
            link_html { title "View evaluation" }
        }
        edit {
            label {}
            sub_class narrow
            display_template {
                <img src="/resources/acs-subsite/Edit16.gif" width="16" height="16" border="0">
            } 
            link_url_eval {[export_vars -base "one-evaluation-edit" { evaluation_id task_id }]}
            link_html { title "Edit evaluation" }
        }
        delete {
            label {}
            sub_class narrow
            display_template {
                <img src="/resources/acs-subsite/Delete16.gif" width="16" height="16" border="0">
            } 
            link_url_eval {[export_vars -base "evaluation-delete" { evaluation_id return_url task_id }]}
            link_html { title "Delete evaluation" }
        }
    }

set orderby [template::list::orderby_clause -orderby -name evaluated_students]

if {[string equal $orderby ""]} {
    set orderby " order by party_name asc"
} 

db_multirow -extend { actions action_url } evaluated_students evaluated_students { *SQL* } {
    
    lappend done_students $party_id
    set grade [format %.2f $grade]
    if { [string eq $online_p "t"] } {
	# working with answer stuff (if it has a file/url attached)
	if { [empty_string_p $answer_data] } {
	    set action "No response"
	} elseif { [regexp "http://" $answer_data] } {
	    set action_url "[export_vars -base "$answer_data" { }]"
	    set action "View answer"
	} else {
	    # we assume it's a file
	    set action_url "[export_vars -base "../../view/$answer_title" { revision_id }]"
	    set action "View answer"
	}
	if { [string eq $action "View answer"] && ([template::util::date::compare $submission_date $evaluation_date] > 0) } {
	    set action "<span style=\"color:red;\">View NEW answer</span>"
	}
	if { [template::util::date::compare $submission_date $due_date] > 0 } {
	    set pretty_submission_date "$pretty_submission_date (late)"
	}
    }
} 

set total_evaluated [db_string count_evaluated_students { *SQL* }]

if { [llength $done_students] > 0 } {
    set processed_clause [db_map processed_clause]
} else {
    set processed_clause ""
}

set not_evaluated_with_answer [db_string get_not_eval_wa { *SQL* }]

#
# working with students that have answered but have not been yet evaluated
#

set elements [list party_name \
		  [list label "Name" \
		       orderby_asc {party_name asc} \
		       orderby_desc {party_name desc}] \
		  answer \
		  [list label "Answer" \
		       link_url_col answer_url \
		       link_html { title "View answer" }] \
		  grade \
		  [list label "Maximun Grade: <input type=text name=\"max_grade\" maxlength=\"6\" size=\"3\" value=\"100\">" \
		       display_template { <input type=text name=grades_wa.@not_evaluated_wa.party_id@ maxlength=\"6\" size=\"3\"> } ] \
		  comments \
		  [list label "Comments" \
		       display_template { <textarea rows="3" cols="15" wrap name=comments_wa.@not_evaluated_wa.party_id@></textarea> } \
		      ] \
		  show_answer \
		  [list label "Allow the students <br> to see the grade?" \
		       display_template { Yes <input checked type=radio name="show_student_wa.@not_evaluated_wa.party_id@" value=t> No <input type=radio name="show_student_wa.@not_evaluated_wa.party_id@" value=f> } \
		      ] \
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

db_multirow -extend { answer answer_url } not_evaluated_wa get_not_evaluated_wa_students { *SQL* } {
    
    lappend done_students $party_id
    if { [string eq $online_p "t"] } {
	set answer "View answer"
	# working with answer stuff (if it has a file/url attached)
	if { [regexp "http://" $answer_data] } {
	    set answer_url [export_vars -base "$answer_data" { }]
	} else {
	    # we assume it's a file
	    set answer_url [export_vars -base "../../view/$answer_title" { revision_id }]
	}
	if { [template::util::date::compare $submission_date $due_date] > 0 } {
	    set pretty_submission_date "$pretty_submission_date <span style=\"color:red;\">(late answer)</span>"
	}
    } 
}

#
# working with students that have not answered and have not been yet evaluated and do not have submited their answers
#

set elements [list party_name \
		  [list label "Name" \
		       orderby_asc {party_name asc} \
		       orderby_desc {party_name desc}] \
		  grade \
		  [list label "Grade over <input type=text name=\"max_grade\" maxlength=\"6\" size=\"3\" value=\"100\">" \
		       display_template { <input type=text name=grades_na.@not_evaluated_na.party_id@ maxlength=\"6\" size=\"3\"> } ] \
		  comments \
		  [list label "Comments" \
		       display_template { <textarea rows="3" cols="15" wrap name=comments_na.@not_evaluated_na.party_id@></textarea> } \
		      ] \
		  show_answer \
		  [list label "Allow the students <br> to see the grade?" \
		       display_template { Yes <input checked type=radio name="show_student_na.@not_evaluated_na.party_id@" value=t> No <input type=radio name="show_student_na.@not_evaluated_na.party_id@" value=f> } \
		      ] \
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
	set not_evaluated_with_no_answer [db_string get_not_evaluated_na { *SQL* }]
	set not_in_clause [db_map not_in_clause]
    } else {
	set not_in_clause ""
    }
    set not_evaluated_with_no_answer [db_string count_not_eval_na { *SQL* }]
    set sql_query [db_map sql_query_groups]
} else {
    set community_id [dotlrn_community::get_community_id]
    if { [llength $done_students] > 0 } {
	set not_in_clause [db_map not_yet_in_clause]
    } else {
	set not_in_clause "where p.member_state = 'approved'"
    }

    # if this page is called from within a community (dotlrn) we have to show only the students

    if { [empty_string_p $community_id] } {
	set not_evaluated_with_no_answer [db_string get_not_evaluated_left { *SQL* }]
	set sql_query [db_map sql_query_individual]
    } else {
	set not_evaluated_with_no_answer [db_string get_community_not_evaluated_left { *SQL* }]
	set sql_query [db_map sql_query_community_individual]
    }

}

db_multirow not_evaluated_na get_not_evaluated_na_students { *SQL* } {
    
}

set grades_sheet_item_id [db_nextval acs_object_id_seq]

 


