ad_page_contract {

    evaluations chunk to be displayed in the index page

}

set package_id [ad_conn package_id]
set user_id [ad_verify_and_get_user_id]
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]

set base_url [ad_conn package_url]

db_1row get_grade_info { *SQL* }

set elements [list task_name \
		  [list label "Name" \
		       link_url_col task_url \
		       orderby_asc {task_name asc} \
		       orderby_desc {task_name desc}] \
		 ]
if { $admin_p } { 
    #admin
    lappend elements task_weight \
	[list label "Weight" \
	     display_template { <center>@grade_tasks_admin.task_weight@%</center> } \
	     orderby_asc {task_weight asc} \
	     orderby_desc {task_weight desc}] 
    set multirow_name grade_tasks_admin
    set actions [list "Edit grades distribution of $grade_name" [export_vars -base "${base_url}admin/grades/distribution-edit" { grade_id }]]
} else { 
    #student
    lappend elements grade \
	[list label "Grade over 100" \
	     display_template { <center>@grade_tasks.grade@</center> } \
	     orderby_asc {grade asc} \
	     orderby_desc {grade desc}] 
    lappend elements comments \
	[list label "Comments" \
	     link_url_col comments_url \
	     link_html { title "View evaluation comments" }]
    lappend elements task_weight \
	[list label "Net value" \
	     display_template { <center>@grade_tasks.task_weight@</center> } \
	     orderby_asc {task_weight asc} \
	     orderby_desc {task_weight desc}] 
    lappend elements answer \
	[list label "" \
	     link_url_col answer_url \
	     link_html { title "View my answer" }]
    set multirow_name grade_tasks
    set actions ""
}

set total_grade 0.00
set max_grade 0.00
set category_weight 0

template::list::create \
    -name grade_tasks \
    -multirow $multirow_name \
    -actions $actions \
    -key task_id \
    -pass_properties { return_url mode base_url } \
    -filters { grade_id } \
    -elements $elements \
    -orderby { default_value task_name } \
    -orderby_name evaluations_orderby

set evaluations_orderby [template::list::orderby_clause -orderby -name grade_tasks]

if { [string equal $evaluations_orderby ""] } {
    set evaluations_orderby " order by task_name asc"
}

if { $admin_p } {
    
    db_multirow -extend { task_url } grade_tasks_admin get_tasks_admin { *SQL* } {
	set task_url [export_vars -base "${base_url}admin/evaluations/student-list" { task_id grade_id }]
	set category_weight [expr $category_weight + $task_weight] 
    }
} else {    
    db_multirow -extend { comments comments_url answer answer_url } grade_tasks get_grade_tasks { *SQL* } {
	
	if { ![empty_string_p $comments] } {
	    set comments "View comments"
	    set comments_url evaluation_view
	}
	
	set over_weight ""
	if {  ![empty_string_p $show_student_p] && $show_student_p } {
	    
	    if { ![empty_string_p $grade] } {
		set grade [format %.2f $grade]
		set over_weight "[format %.2f $task_grade] /"
		set total_grade [expr $total_grade + $task_grade] 
	    } else {
		set grade "Not evaluated"
	    }
	    
	    set max_grade [expr $task_weight + $max_grade] 
	} else {
	    set grade "Not available"
	}
	set task_weight "$over_weight [format %.2f $task_weight]"
	
	# working with answer stuff (if it has a file/url attached)
	if { [empty_string_p $answer_data] } {
	    set answer_url ""
	    set answer ""
	} elseif { [regexp "http://" $answer_data] } {
	    set answer_url "[export_vars -base "$answer_data" { }]"
	    set answer "View my answer"
	} else {
	    # we assume it's a file
	    set answer_url "[export_vars -base "${base_url}view/$answer_title" { }]"
	    set answer "View my answer"
	}
	
	if { $number_of_members > 1 && [string eq [db_string get_group_id { *SQL* }] 0] } {
	    set answer ""
	    set answer_url ""
	    set grade "No group for task"
	}
	
    } 
}

if { $admin_p } {
    set bottom_line "<small>Weight used in $grade_name: ${category_weight}% (of 100% of $grade_name) <br />
                    $grade_name represents ${grade_weight}% of the 100% of the class</small>"
} else {
    set bottom_line "<small>Total points in this category: $total_grade / $max_grade<br />
                     This grade category represents the ${grade_weight}% of the 100% of the class</small>"
}
