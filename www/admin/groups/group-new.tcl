# /packages/evaluation/www/admin/groups/group-new.tcl

ad_page_contract {
	Creates a evaluation group for a task.

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id$
} {
	student_ids:array,integer,notnull
	task_id:naturalnum,notnull
	{return_url [export_vars -base one-task { task_id }]}
} -validate {
	students_to_work_with {
		if { [array size student_ids] == 0  } {
			ad_complain "[_ evaluation.lt_There_must_be_some_st]"
		}
	}
}

set page_title "[_ evaluation.New_Group_]"
set context [list [list "[export_vars -base one-task { task_id }]" "[_ evaluation.Task_Groups_]"] "[_ evaluation.Create_Group_]"]

set current_groups_plus_one [db_string get_groups {* SQL* *}]
set evaluation_group_id [db_nextval acs_object_id_seq]

# if the structure of the multirow datasource ever changes, this needs to be rewritten    
set counter 0
foreach student_id [array names student_ids] {
	if {[info exists student_ids($student_id)]} { 
		incr counter 
		set student_name [db_string get_student_name { *SQL* }]
		set students:${counter}(rownum) $counter
		set students:${counter}(student_name) $student_name
	}
}

set students:rowcount $counter

set export_vars [export_vars -form { student_ids }]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
