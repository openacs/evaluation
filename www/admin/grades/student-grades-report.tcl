# /package/evaluation/www/admin/grades/student-grades-reportindex.tcl

ad_page_contract {
    
    Grades report for one student

    @author jopez@galileo.edu
    @creation-date Jun 2004
    @cvs-id $Id$
    
} {
    student_id:integer,notnull
    {orderby:optional ""}
}

db_1row student_info { *SQL* } 

set portrait [evaluation::get_user_portrait -user_id $student_id { {alt "[_ evaluation.lt_No_portrait_for_stude]"} }]

set page_title "[_ evaluation.lt_Grades_Report_for_stu]"
set context {}
set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

db_multirow grades get_grades { *SQL* } {
	
}

set total_class_grade [format %.2f [lc_numeric [db_string get_total_grade { *SQL* }]]]

ad_return_template
