# /packages/evaluation/www/admin/groups/group-delete.tcl

ad_page_contract {
	Asks for a confirmation before deleting the group

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	evaluation_group_id:naturalnum,notnull
	task_id:naturalnum,notnull
	return_url:optional
}

set page_title "[_ evaluation.Delete_Evaluation_]"
set context [list [list "[export_vars -base one-task { task_id }]" "[_ evaluation.Task_Groups_]"] [list "[export_vars -base one-group { task_id evaluation_group_id }]" "[_ evaluation.One_Group_]"] "[_ evaluation.Delete_Group_]"]

db_1row get_group_info { *SQL* }

set export_vars [export_vars -form { evaluation_group_id task_id return_url }]



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
