# /packages/evaluation/www/admin/grades/grades-types-reports.tcl

ad_page_contract {

	Grades reports of a grade type

	@creation-date Apr 2004
	@author jopez@galileo.edu
	@cvs-id $Id$

} {
	grade_id:integer,notnull
} -validate {
	tasks_for_grade {
		if { [string eq [db_string get_tasks { *SQL* }] 0] } {
			ad_complain "There are no tasks for this grade type."
		}
	}
}

set page_title "Grades Report"
set context [list [list "[export_vars -base grades-reports { }]" "Grades Report"] "One Grade Type"]

set package_id [ad_conn package_id]

set elements [list student_name \
				  [list label "Name"]\
				 ]

db_foreach grade_task { *SQL* } {
	lappend elements task_$task_id \
		[list label "$task_name ($weight %)"]

	append sql_query [db_map task_grade]
} 

lappend elements total_grade \
	[list label "Total"]

append sql_query [db_map grade_total_grade]

template::list::create \
	-name grade_tasks \
	-multirow grade_tasks \
	-key task_id \
	-elements $elements

db_multirow grade_tasks get_grades { *SQL* } {
	
}
