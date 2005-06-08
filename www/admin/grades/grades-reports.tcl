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
	    ad_complain "[_ evaluation.lt_There_are_no_grades_f]"
	}
    }
}

set page_title "[_ evaluation.Grades_Report_]"
set context "[_ evaluation.Grades_Report_]"
set package_id [ad_conn package_id]
set simple_p [parameter::get -parameter "SimpleVersion"]
# we have to decide if we are going to show all the users in the system
# or only the students of a given class (community in dotrln)
# in order to create the groups

set class "list"
if { $simple_p } {
    set class "pbs_list"
}
set community_id [dotlrn_community::get_community_id]
if { [empty_string_p $community_id] } {
    set query_name grades_report
} else {
    set query_name community_grades_report
}

set elements [list student_name \
		  [list label "[_ evaluation.Name_]" \
		       link_url_col student_url \
		       orderby_asc {student_name asc} \
		       orderby_desc {student_name desc}] \
		 ]

db_foreach grade_type { *SQL* } {
    set weight [lc_numeric $weight]
    set grade_label_${grade_id} "${grade_plural_name} ($weight%) <a href=[export_vars -base "grades-type-reports" { grade_id }]><img src=\"/resources/acs-subsite/Zoom16.gif\" width=\"16\" height=\"16\" border=\"0\"></a>"
    append pass_grades " grade_label_${grade_id} "
    lappend elements grade_$grade_id \
	[list label "@grade_label_${grade_id};noquote@" \
	     orderby_asc {grade_$grade_id asc} \
	     orderby_desc {grade_$grade_id desc} \
	    ]

    append sql_query [db_map grade_total_grade]
}


lappend elements total_grade \
    [list label "[_ evaluation.Total_Grade_]" \
	 orderby_asc {total_grade asc} \
	 orderby_desc {total_grade desc} \
	]


append sql_query [db_map class_total_grade]

template::list::create \
    -name grades_report \
    -multirow grades_report \
    -key grade_id \
    -main_class $class \
    -sub_class narrow \
    -elements $elements \
    -pass_properties " $pass_grades " \
    -orderby { default_value student_name } 

if { ![empty_string_p $orderby] } {
    set orderby "[template::list::orderby_clause -orderby -name grades_report]"
} else {
    set orderby " order by student_name asc"
}



db_multirow -extend { student_url } grades_report $query_name { *SQL* } {
    set student_url [export_vars -base "student-grades-report" -url { {student_id $user_id} }]
}
