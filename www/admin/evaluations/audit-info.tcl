# /packages/evaluation/www/admin/evaluations/audit-info.tcl

ad_page_contract {

	Shows the audit info for a given task

	@author jopez
	@creation-date Apr 2004
	@cvs-id $Id$

} {
    task_id:integer,notnull
    {orderby:optional ""}
}

db_1row get_task_info { *SQL* }
set page_title "[_ evaluation.lt_Audit_info_for_task_t]"
set context [list "[_ evaluation.Audit_Info__1]"]

db_multirow parties get_parties { *SQL* } {
		
}

ad_return_template
