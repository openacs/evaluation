# /packages/evaluation/www/admin/groups/group-reuse-2.tcl

ad_page_contract {
	Creates groups for a task from another task

	@author jopez@galileo.edu
	@creation-date Apr 2004
	@cvs-id $Id$
} {
	task_id:integer,notnull
	from_task_id:integer,notnull
} -validate {
	no_groups {
		if { [db_string get_groups_for_task "select count(*) from evaluation_task_groups where task_id = :task_id"] > 0 } {
			ad_complain "There must be no groups for this task in order to copy the groups form another task. You can go back and delete the groups for this task."
		}
	}
}

set package_id [ad_conn package_id]
set creation_user_id [ad_conn user_id]
set creation_ip [ad_conn peeraddr]


db_transaction {

	db_foreach evaluation_group { *SQL* } {
	
		set new_evaluation_group_id [db_nextval acs_object_id_seq]
		
		evaluation::new_evaluation_group -group_id $new_evaluation_group_id -group_name $group_name -task_id $task_id -context $package_id

		db_exec_plsql evaluation_relationship_new { *SQL* }

	}
} on_error { 
    ad_complain "There was an error creating the groups"
 
    ns_log Error "/evaluation/www/admin/groups/new-group-2.tcl choked:  $errmsg" 
         
	ad_return_error "Insert Failed" "This was the error:
               <blockquote> 
                <pre>$errmsg</pre> 
                </blockquote>" 
        ad_script_abort 
} 


ad_returnredirect one-task.tcl?[export_vars task_id] 


