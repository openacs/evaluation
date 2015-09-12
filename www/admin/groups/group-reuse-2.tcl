# /packages/evaluation/www/admin/groups/group-reuse-2.tcl

ad_page_contract {
	Creates groups for a task from another task

	@author jopez@galileo.edu
	@creation-date Apr 2004
	@cvs-id $Id$
} {
	task_id:naturalnum,notnull
	from_task_id:naturalnum,notnull
} -validate {
	no_groups {
	    if { [db_string get_groups_for_task { *SQL* }] > 0 } {
			ad_complain "[_ evaluation.lt_There_must_be_no_grou]"
		}
	}
}

set package_id [ad_conn package_id]
set creation_user_id [ad_conn user_id]
set creation_ip [ad_conn peeraddr]

db_1row task_info { *SQL* }

db_transaction {

	db_foreach evaluation_group { *SQL* } {
	
		set new_evaluation_group_id [db_nextval acs_object_id_seq]
		
		evaluation::new_evaluation_group -group_id $new_evaluation_group_id -group_name $group_name -task_item_id $task_item_id -context $package_id

		db_foreach from_rel { *SQL* }  {
		    db_exec_plsql evaluation_relationship_new { *SQL* }
		}

	}
} on_error { 
    ad_complain "[_ evaluation.lt_There_was_an_error_cr]"
 
    ns_log Error "/evaluation/www/admin/groups/new-group-2.tcl choked:  $errmsg" 
         
	ad_return_error "[_ evaluation.Insert_Failed_]" "[_ evaluation.lt_This_was_the_error___]" 
        ad_script_abort 
} 


ad_returnredirect [export_vars -base one-task.tcl task_id] 



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
