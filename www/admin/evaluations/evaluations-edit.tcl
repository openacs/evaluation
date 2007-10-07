# /packages/evaluaiton/www/admin/evaluations/evaluations-edit.tcl

ad_page_contract {
    Displays the evaluations of students in order to edit them
    
    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    task_id:integer,notnull
    {return_url "student-list?[export_vars -url { task_id }]"}
    grade_id:optional
} 

set page_title "[_ evaluation.Edit_Evaluations_]"
set context [list [list "[export_vars -base student-list { task_id }]" "[_ evaluation.Studen_List_]"] "[_ evaluation.Edit_Evaluations_]"]
set simple_p [parameter::get -parameter "SimpleVersion"]
set max_grade [db_string get_task_weight {}]


set elements [list party_name \
		  [list label "[_ evaluation.Name_]" \
		       orderby_asc {party_name asc} \
		       orderby_desc {party_name desc}] \
		  answer \
		  [list label "[_ evaluation.Answer_]" \
		       display_template { @evaluated_students.answer;noquote@ } \
		       link_url_col answer_url \
		       link_html { title "View answer" }] \
		  submission_date_pretty \
		  [list label "[_ evaluation.Submission_Date_]" \
		       orderby_asc {submission_date asc} \
		       orderby_desc {submission_date desc}] \
		  grade \
		  [list label "[_ evaluation.Maximun_Grade_] <if $simple_p eq 0><input type=text name=\"max_grade\" maxlength=\"6\" size=\"3\" value=\"$max_grade\"></if><else>$max_grade<input type=hidden name=max_grade value=$max_grade></else>" \
		       display_template { 
			   <input type=text name=grades.@evaluated_students.party_id@ value=\"@evaluated_students.grade@\" maxlength=\"6\" size=\"4\"> } ] \
		  edit_reason \
		  [list label "[_ evaluation.Edit_Reason_]" \
		       display_template { <textarea rows="3" cols="15" name=reasons.@evaluated_students.party_id@></textarea> } \
		      ] \
		  show_student_p \
		  [list label "[_ evaluation.lt_Allow_the_students_br]" \
		       display_template { Yes <input @evaluated_students.radio_yes_checked@ type=radio name="show_student.@evaluated_students.party_id@" value=t> No <input @evaluated_students.radio_no_checked@ type=radio name="show_student.@evaluated_students.party_id@" value=f> } \
		      ] \
		 ]

template::list::create \
    -name evaluated_students \
    -multirow evaluated_students \
    -key task_id \
    -filters { task_id {} } \
    -elements $elements

set orderby [template::list::orderby_clause -orderby -name evaluated_students]

if {[string equal $orderby ""]} {
    set orderby " order by party_name asc"
} 

db_multirow -extend { answer answer_url radio_yes_checked radio_no_checked submission_date_pretty } evaluated_students get_evaluated_students { *SQL* } {
    
    set grade [format %0.2f [expr $grade*$max_grade/100]]
    
    if { [string eq $online_p "t"] } {
	if { [db_0or1row get_answer_info { *SQL* }] } {
	    
	    # working with answer stuff (if it has a file/url attached)
	    if { [empty_string_p $answer_data] } {
		set answer "[_ evaluation.No_response_]"
	    } elseif { [string eq $answer_title "link"] } {
		set answer_url "[export_vars -base "$answer_data" { }]"
		set answer "[_ evaluation.View_answer_]"
	    } else {
		# we assume it's a file
		set answer_url "[export_vars -base "[ad_conn package_url]view/$answer_title" { revision_id }]"
		set answer "[_ evaluation.View_answer_]"
	    }
	    if { ![string eq $answer "[_ evaluation.No_response_]"] && [db_string compare_evaluation_date { *SQL* } -default 0] } {
		set answer "<span style=\"color:red;\"> [_ evaluation.View_NEW_answer_]</span>"
	    }
	    set submission_date_pretty [lc_time_fmt $submission_date_ansi "%q %r"]
	    if { [db_string compare_submission_date { *SQL* } -default 0] } {
		set submission_date_pretty "$submission_date_pretty [_ evaluation.late__1]"
	    }
	}
    }
    
    if { [string eq $show_student_p "t"] } {
	set radio_yes_checked "checked"
	set radio_no_checked ""
    } else {
	set radio_yes_checked ""
	set radio_no_checked "checked"
    }
    
    set evaluation_ids($party_id) $evaluation_id
    set item_to_edit_ids($party_id) $item_id
} 

set grades_sheet_item_id [db_nextval acs_object_id_seq]
set export_vars [export_vars -form { evaluation_ids item_to_edit_ids }]

ad_return_template
