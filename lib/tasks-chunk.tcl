ad_page_contract {

    task chunk to be displayed in the index page

}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]

db_1row grade_names { *SQL* }
set base_url [ad_conn package_url]

set mode display
set return_url "[ad_conn url]?[ns_conn query]"

set elements [list task_name \
                  [list label "[_ evaluation-portlet.Name_]" \
                       link_url_col task_url \
                       orderby_asc {task_name asc} \
                       orderby_desc {task_name desc}] \
                  due_date_pretty \
                  [list label "[_ evaluation-portlet.Due_date_]" \
                       orderby_asc {due_date_ansi asc} \
                       orderby_desc {due_date_ansi desc}] \
                 ]

if { $admin_p } { 
    #admin
    lappend elements solution \
        [list label "" \
             link_url_col solution_url \
             link_html { title "[_ evaluation-portlet.Addedit_solution_]" }]
    lappend elements groups_admin \
        [list label "" \
             link_url_col groups_admin_url \
             link_html { title "[_ evaluation-portlet.lt_Groups_administration]" }]
    lappend elements view \
        [list label "" \
             sub_class narrow \
             display_template {<img src="/resources/acs-subsite/Zoom16.gif" width="16" height="16" style="border:0px" alt="#evaluation-portlet.View_task_#">} \
             link_url_eval {[export_vars -base "${base_url}admin/tasks/task-add-edit" { grade_id task_id mode return_url }]} \
             link_html { title "[_ evaluation-portlet.View_task_]" }]
    lappend elements edit \
        [list label "" \
             sub_class narrow \
             display_template {<img src="/resources/acs-subsite/Edit16.gif" width="16" height="16" style="border:0px" alt="#evaluation-portlet.Edit_task_#">} \
             link_url_eval {[export_vars -base "${base_url}admin/tasks/task-add-edit" { grade_id return_url item_id task_id }]} \
             link_html { title "[_ evaluation-portlet.Edit_task_]" }] 
    lappend elements delete \
        [list label "" \
             sub_class narrow \
             display_template {<img src="/resources/acs-subsite/Delete16.gif" width="16" height="16" style="border:0px" alt="#evaluation-portlet.Delete_task_#">} \
             link_url_eval {[export_vars -base "${base_url}admin/tasks/task-delete" { grade_id task_id return_url }]} \
             link_html { title "[_ evaluation-portlet.Delete_task_]" }]
    
    set multirow_name tasks_admin
    set actions [list "[_ evaluation-portlet.Add_grade_name_]" [export_vars -base "${base_url}admin/tasks/task-add-edit" { return_url grade_id }] ]
} else { 
    #student
    lappend elements answer \
        [list label "" \
             link_url_col answer_url \
             link_html { title "[_ evaluation-portlet.Addedit_answer_]" }]
    lappend elements view \
        [list label "" \
             sub_class narrow \
             display_template {<img src="/resources/acs-subsite/Zoom16.gif" width="16" height="16" style="border:0px" alt="#evaluation-portlet.View_task_#">} \
             link_url_eval {[export_vars -base "${base_url}task-view" { grade_id task_id return_url }]} \
             link_html { title "[_ evaluation-portlet.View_task_]" }]
    set multirow_name tasks
    set actions ""
}

set suffix [ad_generate_random_string 4]
set list_name "tasks_${suffix}"
template::list::create \
    -name $list_name \
    -multirow $multirow_name \
    -actions $actions \
    -key task_id \
    -pass_properties { return_url mode base_url grade_id } \
    -filters { grade_id {} } \
    -no_data "[_ evaluation.No_assignments_]" \
    -orderby_name assignments_orderby \
    -elements $elements \
    -orderby { default_value task_name }

set assignments_orderby [template::list::orderby_clause -orderby -name $list_name]

if {$assignments_orderby eq ""} {
    set assignments_orderby " order by task_name asc"
}

if { $admin_p } { 

    db_multirow -extend { solution_url due_date_pretty solution solution_mode task_url groups_admin groups_admin_url } tasks_admin get_tasks_admin { *SQL* } {

        set due_date_pretty [lc_time_fmt $due_date_ansi "%q %X"]

        # working with task stuff (if it has a file/url attached)
        if { $task_data eq "" } {
            set task_url "[export_vars -base "${base_url}task-view" { grade_id task_id return_url }]"
            set task_name "[_ evaluation-portlet.task_name_No_data_]"
        } elseif {$task_title eq "link"} {

            # there is a bug in the template::list, if the url does not has a http://, ftp://, the url is not absolute,
            # so we have to deal with this case
            array set community_info [site_node::get -url "[dotlrn_community::get_community_url [dotlrn_community::get_community_id]][evaluation::package_key]"]
            if { ![regexp ([join [split [parameter::get -parameter urlProtocols -package_id $community_info(package_id)] ","] "|"]) "$task_data"] } {
                set task_data "http://$task_data"
            } 
            set task_url "[export_vars -base "$task_data" { }]"
            set task_name "[_ evaluation-portlet.task_name_URL_]"
            
        } else {
            # we assume it's a file
            set task_url "[export_vars -base "${base_url}view/$task_title" { revision_id }]"
            set task_name "$task_name ([lc_numeric $content_length] Kb - ${pretty_mime_type})"
        }

        if { [db_0or1row solution_info { *SQL* }] } { 
            set solution_mode display
            set solution_url "[export_vars -base "${base_url}admin/tasks/solution-add-edit" { grade_id task_id solution_id return_url solution_mode }]"
            set solution "[_ evaluation-portlet.ViewEdit_Solution_]"
        } else {
            set solution_mode edit
            set solution_url "[export_vars -base "${base_url}admin/tasks/solution-add-edit" { grade_id task_id return_url solution_mode }]"
            set solution "[_ evaluation-portlet.Upload_Solution_]"
        }

        if { $number_of_members ne "1" } {
            set groups_admin_url "[export_vars -base "${base_url}admin/groups/one-task" { grade_id task_id }]"
            set groups_admin "[_ evaluation-portlet.Groups_Admin_]"     
        }

    } 
} else {
    db_multirow -extend { task_url solution_url solution due_date_pretty solution_mode answer answer_url } tasks get_tasks { *SQL* } {

        set answer_mode display
        set due_date_pretty [lc_time_fmt $due_date_ansi "%q %r"]
        # working with task stuff (if it has a file/url attached)
        if { $task_data eq "" } {
            set task_url "[export_vars -base "${base_url}task-view" { grade_id task_id return_url }]"
            set task_name "[_ evaluation-portlet.task_name_No_data_]"
        } elseif {$task_title eq "link"} {

            # there is a bug in the template::list, if the url does not has a http://, ftp://, the url is not absolute,
            # so we have to deal with this case
            array set community_info [site_node::get -url "[dotlrn_community::get_community_url [dotlrn_community::get_community_id]][evaluation::package_key]"]
            if { ![regexp ([join [split [parameter::get -parameter urlProtocols -package_id $community_info(package_id)] ","] "|"]) "$task_data"] } {
                set task_data "http://$task_data"
            } 
            set task_url "[export_vars -base "$task_data" { }]"
            set task_name "[_ evaluation-portlet.task_name_URL_]"

        } else {
            # we assume it's a file
            set task_url "[export_vars -base "${base_url}view/$task_title" { revision_id }]"
            set task_name "$task_name ([lc_numeric $content_length] Kb - ${pretty_mime_type})"
        }

        if {$online_p == "t"} {
            if { [db_string compare_due_date { *SQL* } -default 0] } {
                if { ![db_0or1row answer_info { *SQL* }] } {
                    set answer "[_ evaluation-portlet.submit_answer_]"
                    set answer_mode edit
                    set answer_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id return_url answer_mode }]"
                } else { 
                    set answer "[_ evaluation-portlet.submit_answer_again_]"
                    set answer_mode display
                    set answer_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id answer_id return_url answer_mode }]"
                }
            } elseif {$late_submit_p == "t"} {
                if { ![db_0or1row answer_info { *SQL* }] } {
                    set answer "[_ evaluation.lt_Submit_answer_span_st]"
                    set answer_mode edit
                    set answer_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id return_url answer_mode }]"
                } else {
                    set answer "[_ evaluation.lt_Submit_answer_again_s]"
                    set answer_mode display
                    set answer_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id answer_id return_url answer_mode }]"
                }
            }
            if { $number_of_members > 1 && [string equal [db_string get_group_id { *SQL* }] "0"] } {
                set answer "[_ evaluation-portlet.No_group_for_task_]"
                set answer_url ""
            }
        }
        
    } 
}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
