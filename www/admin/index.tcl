# /package/evaluation/www/index.tcl

ad_page_contract {
	
	Index page for evaluation package

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$

}

set page_title "Evaluation Index"
set context {}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]

db_multirow grades get_grades { *SQL* } {
	
}

set assignments_notification_chunk [notification::display::request_widget \
							-type one_assignment_notif \
							-object_id $package_id \
							-pretty_name "Assignments" \
							-url [ad_conn url] \
						   ]

set evaluations_notification_chunk [notification::display::request_widget \
							-type one_evaluation_notif \
							-object_id $package_id \
							-pretty_name "Evaluations" \
							-url [ad_conn url] \
						   ]

ad_return_template