# /packages/evaluation/www/admin/groups/group-member-add-2.tcl

ad_page_contract {
	Associates a student whith a group

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	evaluation_group_id:integer,notnull
	task_id:integer,notnull
	student_id:integer,notnull
}

set creation_user_id [ad_conn user_id]
set creation_ip [ad_conn peeraddr]
set package_id [ad_conn package_id]

db_exec_plsql associate_student { *SQL* }		

ad_returnredirect "one-task?[export_vars -url { task_id }]"
