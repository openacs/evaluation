# /packages/evaluation/www/admin/groups/group-new-2.tcl

ad_page_contract {
	Creates a evaluation group for a task.

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	student_ids:array,integer,notnull
	task_id:naturalnum,notnull
	evaluation_group_id:naturalnum,notnull
	group_name:notnull
} -validate {
	students_to_work_with {
		if { [array size student_ids] == 0  } {
			ad_complain "[_ evaluation.lt_There_must_be_some_st]"
		}
	}
}

set creation_user_id [ad_conn user_id]
set creation_ip [ad_conn peeraddr]
set package_id [ad_conn package_id]

db_1row task_info { *SQL* }

db_transaction {
	evaluation::new_evaluation_group -group_id $evaluation_group_id -group_name $group_name -task_item_id $task_item_id -context $package_id
	foreach student_id [array names student_ids] {
		if {[info exists student_ids($student_id)]} { 
			db_exec_plsql evaluation_relationship_new { *SQL* }
		}
	}
}

ad_returnredirect [export_vars -base one-task { task_id }]



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
