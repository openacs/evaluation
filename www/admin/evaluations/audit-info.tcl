# /packages/evaluation/www/admin/evaluations/audit-info.tcl

ad_page_contract {

	Shows the audit info for a given task

	@author jopez
	@creation-date Apr 2004
	@cvs-id $Id$

} {
	task_id:integer,notnull
}

db_1row get_task_info { *SQL* }
set page_title "Audit info for task"
set context [list "Audit Info"]

db_multirow parties get_parties { *SQL* } {
	
	
}

ad_return_template
