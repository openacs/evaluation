# /packages/evaluaiton/www/admin/evaluations/evaluations-edit.tcl

ad_page_contract {
	Displays the evaluations of students in order to edit them
	
    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
	task_id:integer,notnull
	{return_url "student-list?[export_vars -url { task_id }]"}
} 

set page_title "Edit Evaluations"
set context [list [list "[export_vars -base student-list { task_id }]" "Studen List"] "Edit Evaluations"]

set elements [list party_name \
				  [list label "Name" \
					   orderby_asc {party_name asc} \
					   orderby_desc {party_name desc}] \
				  answer \
				  [list label "Answer" \
					   link_url_col answer_url \
					   link_html { title "View answer" }] \
				  pretty_submission_date \
				  [list label "Submission Date" \
					   orderby_asc {submission_date asc} \
					   orderby_desc {submission_date desc}] \
				  grade \
				  [list label "Maximun Grade: <input type=text name=\"max_grade\" maxlength=\"6\" size=\"3\" value=\"100\">" \
					   display_template { <input type=text name=grades.@evaluated_students.party_id@ value=\"@evaluated_students.grade@\" maxlength=\"6\" size=\"3\"> } ] \
				  edit_reason \
				  [list label "Edit Reason" \
					   display_template { <textarea rows="3" cols="15" wrap name=reasons.@evaluated_students.party_id@></textarea> } \
					  ] \
				  show_student_p \
				  [list label "Allow the students <br> to see the grade?" \
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

db_multirow -extend { answer answer_url radio_yes_checked radio_no_checked } evaluated_students get_evaluated_students { *SQL* } {
	
	set grade [format %.2f $grade]
	if { [string eq $online_p "t"] } {
		# working with answer stuff (if it has a file/url attached)
		if { [empty_string_p $answer_data] } {
			set answer "No response"
		} elseif { [regexp "http://" $answer_data] } {
			set answer_url "[export_vars -base "$answer_data" { }]"
			set answer "View answer"
		} else {
			# we assume it's a file
			set answer_url "[export_vars -base "[ad_conn package_url]view/$answer_title" { }]"
		}
		if { ![string eq $answer "No response"] && ([template::util::date::compare $submission_date $evaluation_date] > 0) } {
			append answer_url "<span style=\"color:red;\"> (NEW answer)</span>"
		}
		if { [template::util::date::compare $submission_date $due_date] > 0 } {
			set pretty_submission_date "$pretty_submission_date (late)"
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
