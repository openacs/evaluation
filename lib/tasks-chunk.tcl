ad_page_contract {

    task chunk to be displayed in the index page

}

set package_id [ad_conn package_id]
set user_id [ad_verify_and_get_user_id]
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]

set grade_name [db_string grade_name { *SQL* }]
set base_url [ad_conn package_url]

set mode display
set return_url "[ad_conn url]?[export_vars { grade_id }]"

set elements [list task_name \
		  [list label "Name" \
		       link_url_col task_url \
		       orderby_asc {task_name asc} \
		       orderby_desc {task_name desc}] \
		  pretty_due_date \
		  [list label "Due date" \
		       orderby_asc {pretty_due_date asc} \
		       orderby_desc {pretty_due_date desc}] \
		 ]

if { $admin_p } { 
    #admin
    lappend elements solution \
	[list label "" \
	     link_url_col solution_url \
	     link_html { title "Add/edit solution" }]
    lappend elements audit_info \
	[list label "" \
	     link_url_col audit_info_url \
	     link_html { title "Audit info" }]
    lappend elements groups_admin \
	[list label "" \
	     link_url_col groups_admin_url \
	     link_html { title "Groups administration" }]
    lappend elements view \
	[list label "" \
	     sub_class narrow \
	     display_template {<img src="/resources/acs-subsite/Zoom16.gif" width="16" height="16" border="0">} \
	     link_url_eval {[export_vars -base "${base_url}admin/tasks/task-add-edit" { grade_id task_id return_url mode }]} \
	     link_html { title "View task" }]
    lappend elements edit \
	[list label "" \
	     sub_class narrow \
	     display_template {<img src="/resources/acs-subsite/Edit16.gif" width="16" height="16" border="0">} \
	     link_url_eval {[export_vars -base "${base_url}admin/tasks/task-add-edit" { return_url item_id grade_id task_id }]} \
	     link_html { title "Edit task" }] 
    lappend elements delete \
	[list label "" \
	     sub_class narrow \
	     display_template {<img src="/resources/acs-subsite/Delete16.gif" width="16" height="16" border="0">} \
	     link_url_eval {[export_vars -base "${base_url}admin/tasks/task-delete" { grade_id task_id return_url }]} \
	     link_html { title "Delete task" }]
    
    set multirow_name tasks_admin
    set actions [list "Add $grade_name" [export_vars -base "${base_url}admin/tasks/task-add-edit" { return_url grade_id }] ]
} else { 
    #student
    lappend elements answer \
	[list label "" \
	     link_url_col answer_url \
	     link_html { title "Add/edit answer" }]
    lappend elements view \
	[list label "" \
	     sub_class narrow \
	     display_template {<img src="/resources/acs-subsite/Zoom16.gif" width="16" height="16" border="0">} \
	     link_url_eval {[export_vars -base "${base_url}task-view" { grade_id task_id return_url }]} \
	     link_html { title "View task" }]
    set multirow_name tasks
    set actions ""
}

template::list::create \
    -name tasks \
    -multirow $multirow_name \
    -actions $actions \
    -key task_id \
    -pass_properties { return_url mode base_url } \
    -filters { grade_id {} } \
    -elements $elements \
    -orderby_name assignments_orderby \
    -orderby { default_value task_name }

set assignments_orderby [template::list::orderby_clause -orderby -name tasks]

if {[string equal $assignments_orderby ""]} {
    set assignments_orderby " order by task_name asc"
}

if { $admin_p } { 

    db_multirow -extend { solution_url solution solution_mode task_url audit_info audit_info_url groups_admin groups_admin_url } tasks_admin get_tasks_admin { *SQL* } {
	# working with task stuff (if it has a file/url attached)
	if { [empty_string_p $task_data] } {
	    set task_url "[export_vars -base "${base_url}task-view" { grade_id task_id return_url }]"
	    set task_name "$task_name (No data)"
	} elseif { [regexp "http://" $task_data] } {
	    set task_url "[export_vars -base "$task_data" { }]"
	    set task_name "$task_name (URL)"
	} else {
	    # we assume it's a file
	    set task_url "[export_vars -base "${base_url}view/$task_title" { revision_id }]"
	    set task_name "$task_name ([format %.0f [expr ($content_length/1024)]] Kb)"
	}

	if { ![empty_string_p $solution_id] } { 
	    set solution_mode display
	    set solution_url "[export_vars -base "${base_url}admin/tasks/solution-add-edit" { grade_id task_id solution_id return_url solution_mode }]"
	    set solution "View/Edit Solution"
	} else {
	    set solution_mode edit
	    set solution_url "[export_vars -base "${base_url}admin/tasks/solution-add-edit" { grade_id task_id return_url solution_mode }]"
	    set solution "Upload Solution"
	}

	set audit_info_url "[export_vars -base "${base_url}admin/evaluations/audit-info" { grade_id task_id }]"
	set audit_info "Audit Info."

	if { ![string eq $number_of_members 1] } {
	    set groups_admin_url "[export_vars -base "${base_url}admin/groups/one-task" { grade_id task_id }]"
	    set groups_admin "Groups Admin."		
	}

    } 
} else {
    db_multirow -extend { task_url solution_url solution solution_mode answer answer_url } tasks get_tasks { *SQL* } {
	set answer_mode display

	# working with task stuff (if it has a file/url attached)
	if { [empty_string_p $task_data] } {
	    set task_url "[export_vars -base "${base_url}task-view" { grade_id task_id return_url }]"
	    set task_name "$task_name (No data)"
	} elseif { [regexp "http://" $task_data] } {
	    set task_url "[export_vars -base "$task_data" { }]"
	    set task_name "$task_name (URL)"
	} else {
	    # we assume it's a file
	    set task_url "[export_vars -base "${base_url}view/$task_title" { revision_id }]"
	    set task_name "$task_name ([format %.0f [expr ($content_length/1024)]] Kb)"
	}

	if { [string eq $online_p "t"] } {
	    if { ([template::util::date::compare $due_date [template::util::date::now]] > 0) } {
		if { [empty_string_p $answer_id] } {
		    set answer "submit answer"
		    set answer_mode edit
		    set answer_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id return_url answer_mode }]"
		} else { 
		    set answer "submit answer again"
		    set answer_mode display
		    set answer_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id answer_id return_url answer_mode }]"
		}
	    } elseif { [string eq $turn_in_late_p "t"] } {
		if { [empty_string_p $answer_id] } {
		    set answer "submit answer <style font-color:red>late</style>"
		    set answer_mode edit
		    set answer_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id return_url answer_mode }]"
		} else {
		    set answer "submit answer <style font-color:red>late</style> again"
		    set answer_mode display
		    set answer_url "[export_vars -base "${base_url}admin/tasks/solution-add-edit" { grade_id task_id answer_id return_url solution_mode }]"
		}
	    }
	    if { $number_of_members > 1 && [string eq [db_string get_group_id { *SQL* }] 0] } {
		set answer ""
		set answer_url ""
	    }
	}
	
    } 

}