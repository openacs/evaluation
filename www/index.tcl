# /package/evaluation/www/index.tcl

ad_page_contract {
    
    Index page for evaluation package

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
    
} {
    {assignments_orderby ""}
    {evaluations_orderby ""}
}

set page_title "[_ evaluation.Evaluation_Index_]"
set context {}
set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]

db_multirow grades get_grades { *SQL* } {
	
}

set total_class_grade [format %.2f [lc_numeric [db_string get_total_grade { *SQL* }]]]

set notification_chunk [notification::display::request_widget \
							-type one_assignment_notif \
							-object_id $package_id \
							-pretty_name "[_ evaluation.Assignments_]" \
							-url [ad_conn url] \
						   ]

ad_return_template