# /packages/evaluation/www/admin/grades/grades-reports.tcl

ad_page_contract {

	Grades reports of a group

	@creation-date Apr 2004
	@author jopez@galileo.edu
	@cvs-id $Id$

} {
	{orderby ""}
} -validate {
	grades_for_package {
		if { [string eq [db_string package_grades { *SQL* }] 0] } {
			ad_complain "There are no grades for this group."
		}
	}
}

set page_title "Grades Report"
set context "Grades Report"
set package_id [ad_conn package_id]

set elements [list student_name \
				  [list label "Name" \
					   link_url_col student_url \
					   orderby_asc {student_name asc} \
					   orderby_desc {student_name desc}] \
				 ]

db_foreach grade_type { *SQL* } {
	lappend elements grade_$grade_id \
		[list label "<a href=[export_vars -base "grades-type-reports" { grade_id }]>$grade_name ($weight %)</a>"]

	append sql_query [db_map grade_total_grade]
}

lappend elements total_grade \
	[list label "Total Grade" \
		 orderby_asc {total_grade asc} \
		 orderby_desc {total_grade desc} \
   ]

append sql_query [db_map class_total_grade]

template::list::create \
	-name grades_report \
	-multirow grades_report \
	-key grade_id \
	-elements $elements \
	-orderby { default_value student_name }

if { ![empty_string_p $orderby] } {
    set orderby "[template::list::orderby_clause -orderby -name grades_report]"
} else {
    set orderby " order by student_name asc"
}


		
db_multirow grades_report grades_report { *SQL* } {
	
}
