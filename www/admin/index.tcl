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
# [permission::permission_p -party_id $user_id -object_id $package_id -privilege read]

db_multirow grades get_grades { *SQL* } {
	
}

ad_return_template