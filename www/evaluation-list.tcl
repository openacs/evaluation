# /packages/evaluation/www/task-list.tcl

ad_page_contract {
	
	Display the evaluations for the group

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$

} -query {
	{orderby:optional}
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]
#set admin_p 0

if { $admin_p } {
	set actions "<a href=[export_vars -base "admin/grades/grades" { }]>Grade Distribution</a>"
} else {
	set actions "Total current grade: [format %.2f [db_string total_grade { *SQL* }]] / [format %.2f [db_string max_grade { *SQL* }]]"
}

set page_title "Evaluations List"
set context "Evaluations List"

db_multirow grades get_grades { *SQL* } {	
}


