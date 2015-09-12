# /packages/evaluation/www/admin/evaluations/audit-info.tcl

ad_page_contract {

	Shows the audit info for a given task

	@author jopez
	@creation-date Apr 2004
	@cvs-id $Id$

} {
    task_id:naturalnum,notnull
    {orderby:token,optional ""}
}

db_1row get_task_info { *SQL* }
set page_title "[_ evaluation.Audit_info_for_task_]"
set context [list "[_ evaluation.Audit_Info__1]"]

db_multirow parties get_parties { *SQL* } {
		
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
