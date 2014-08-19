# /packages/evaluation/www/admin/grades/grades-types-reports.tcl

ad_page_contract {

	Grades reports of a grade type

	@creation-date Apr 2004
	@author jopez@galileo.edu
	@cvs-id $Id$

} {
	{orderby ""}
	grade_id:naturalnum,notnull
} -validate {
	tasks_for_grade {
		if {[db_string get_tasks { *SQL* }] eq "0"} {
			ad_complain "[_ evaluation.lt_There_are_no_tasks_fo_1]"
		}
	}
}

set page_title "[_ evaluation.Grades_Report_]"
set context [list [list "[export_vars -base grades-reports { }]" "[_ evaluation.Grades_Report_]"] "[_ evaluation.One_Grade_Type_]"]

set package_id [ad_conn package_id]

# we have to decide if we are going to show all the users in the system
# or only the students of a given class (community in dotrln)
# in order to create the groups

set community_id [dotlrn_community::get_community_id]
if { $community_id eq "" } {
    set query_name get_grades
} else {
    set query_name community_get_grades
}

set elements [list student_name \
		  [list label "[_ evaluation.Name_]" \
		       link_url_col student_url \
		       orderby_asc {student_name asc} \
		       orderby_desc {student_name desc} \
		      ]\
		 ]

db_foreach grade_task { *SQL* } {
    lappend elements task_$task_id \
	[list label "$task_name (${weight}%)" \
	     orderby_asc {task_$task_id asc} \
	     orderby_desc {task_$task_id desc} \
	    ]
    
    append sql_query [db_map task_grade]
} 

lappend elements total_grade \
	[list label "[_ evaluation.Total_]" \
		 orderby_asc {total_grade asc} \
		 orderby_desc {total_grade desc} \
		]

append sql_query [db_map grade_total_grade]

template::list::create \
	-name grade_tasks \
	-multirow grade_tasks \
	-key task_id \
	-filters { grade_id {} } \
	-elements $elements \
	-orderby { default_value student_name } 

set orderby [template::list::orderby_clause -orderby -name grade_tasks]

if {$orderby eq ""} {
    set task_order " order by student_name asc"
}

db_multirow -extend { student_url } grade_tasks $query_name " *SQL* " {
    set student_url [export_vars -base "student-grades-report" -url { {student_id $user_id} }]
}
