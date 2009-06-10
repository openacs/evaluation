ad_page_contract {
    
    evaluations chunk to be displayed in the index page
    
}

set package_id [ad_conn package_id]
set evaluation_id [evaluation_evaluations_portlet::get_package_id_from_key -package_key "evaluation"]
set user_id [ad_verify_and_get_user_id]
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]
set simple_p  [parameter::get -parameter "SimpleVersion" -package_id $evaluation_id]
set base_url "[ad_conn package_url]/"
set return_url "[ad_conn url]?[ns_conn query]"
set class "list"
set bulk_actions ""
db_1row get_grade_info { *SQL* }

set grade_plural_name [lang::util::localize $grade_plural_name]
set grade_name [lang::util::localize $grade_name]
set low_name $grade_plural_name
set grade_plural_name [string toupper $grade_plural_name]

set submitted_label "<div style='text-align:center'>[_ evaluation-portlet.lt_smallTotal_points_in__1]</div>"

if { $admin_p } {
    if { $simple_p } {
	set bottom_line "[_ evaluation-portlet.lt_smallWeight_used_in_g]"
    } else {
	set bottom_line ""
	
    }
} else {
    set bottom_line ""
}


if { $simple_p } {
    set class "pbs_list"
    set grade_of_label "<text class=blue>[_ evaluation-portlet.maximum]</text>" 
} else {
    set grade_of_label ""
}
set elements [list task_name \
		  [list label "[_ evaluation-portlet.Name_]" \
		       link_url_col task_url \
		       orderby_asc {task_name asc} \
		       aggregate "" \
		       aggregate_label "@bottom_line;noquote@"\
		       orderby_desc {task_name desc}]]
if { $admin_p } { 
    #admin
    if { $simple_p } {
    	lappend elements perfect_score \
	    [list label "[_ evaluation-portlet.points_value]" \
		 display_template { <div style="text-align:center">@grade_tasks_admin.perfect_score@</div> } \
		 orderby_asc {perfect_score asc} \
		 aggregate "" \
		 aggregate_label "@max_grade_label;noquote@" \
		 orderby_desc {perfect_score desc}] 
    }
    lappend elements task_weight \
	[list label "[_ evaluation-portlet.Weight_]" \
	     display_template { <div style="text-align:center;">@grade_tasks_admin.task_weight@%</div> } \
	     orderby_asc {task_weight asc} \
	     orderby_desc {task_weight desc} \
	     aggregate "" \
	     aggregate_label "@max_weight_label;noquote@"]  
    if { $simple_p } {
	lappend elements solution \
	    [list label "<div style='text-align:center'>[_ evaluation-portlet.solution]</div>" \
		 display_template "<div style='text-align:center'>@grade_tasks_admin.solution@</div>" \
		 link_url_col solution_url \
		 aggregate "" \
		 aggregate_label "@solution_label;noquote@"]
	lappend elements grade \
	    [list label "[_ evaluation-portlet.grade]" \
		 link_url_col grade_url \
		 display_template { <div style="text-align:center">[_ evaluation-portlet.evaluate]</div> } ]
	lappend elements edit \
	    [list label "" \
		 sub_class narrow \
		 display_template {<div style="text-align:center"><a href=${base_url}admin/tasks/task-add-edit?grade_id=$grade_id&return_url=$return_url&task_id=@grade_tasks_admin.task_id@>[_ evaluation-portlet.edit]</a><br><a href=${base_url}admin/tasks/task-delete?grade_id=$grade_id&return_url=$return_url&task_id=@grade_tasks_admin.task_id@>[_ evaluation-portlet.delete]</a></div>}]
    } else {
	lappend elements audit_info \
	    [list label "" \
		 link_url_col audit_info_url \
		 link_html { title "[_ evaluation-portlet.Audit_info_]" }]
	set bulk_actions [list "[_ evaluation-portlet.lt_Edit_grades_distribut]" [export_vars -base "${base_url}admin/grades/distribution-edit" { grade_id }]]
	
    }
    set multirow_name grade_tasks_admin
    set actions "<a href=\"${base_url}admin/tasks/task-add-edit?grade_id=$grade_id&return_url=$return_url\" class=\"tlmidnav\"><img src=\"/resources/evaluation/cross.gif\" width=\"10\" height=\"9\" hspace=\"5\" vspace=\"1\" border=\"0\" align=\"absmiddle\">\#evaluation-portlet.Add_grade_name_\#</a><a href=\"${base_url}admin/grades/distribution-edit?grade_id=$grade_id\" class=\"tlmidnav\"><img src=\"/resources/evaluation/cross.gif\" width=\"10\" height=\"9\" hspace=\"5\" vspace=\"1\" border=\"0\" align=\"absmiddle\">\#evaluation-portlet.edit_grade_scale\#</a>"
    
} else { 
    #student
    if { $simple_p } {
        lappend elements submitted \
	    [list label "<div style='text-align:center'>[_ evaluation-portlet.Submitted]</div>" \
		 display_template { <div style="text-align:center">@grade_tasks.submitted_date;noquote@</div> } \
		 aggregate "" \
		 link_url_col submitted_date_url \
		 aggregate_label "@submitted_label;noquote@" ]
	
	lappend elements task_grade \
	    [list label "[_ evaluation-portlet.Points]" \
		 display_template { <div style="text-align:center;">@grade_tasks.task_grade@</div> } \
		 aggregate "" \
		 aggregate_label "@max_grade_label;noquote@" ]
	lappend elements task_weight \
	    [list label "[_ evaluation-portlet.Total_Points]" \
		 display_template { <div style="text-align:center">@grade_tasks.perfect_score@</div> } \
		 orderby_asc {task_weight asc} \
		 orderby_desc {task_weight desc} \
		 aggregate "" \
		 aggregate_label "@max_weight_label;noquote@"]
    } 
    lappend elements grade \
	[list label "[_ evaluation-portlet.Grade_over_100_]" \
	     display_template { <div style="text-align:center">@grade_tasks.grade@</div> } \
	     aggregate "" \
	     aggregate_label "@grade_of_label;noquote@"]
    
    lappend elements comments \
	[list label "[_ evaluation-portlet.Comments_]" \
	     link_url_col comments_url \
	     link_html { title "[_ evaluation-portlet.lt_View_evaluation_comme]" }]
    
    if {!$simple_p} {
	lappend elements task_weight \
	    [list label "[_ evaluation-portlet.Net_Value_]" \
		 display_template { <div style="text-align:center">@grade_tasks.task_weight@</div> } \
		 orderby_asc {task_weight asc} \
		 orderby_desc {task_weight desc}] 
	
    }
    lappend elements answer \
	[list label "" \
	     display_template {<a href=@grade_tasks.answer_url@ target=new>@grade_tasks.answer;noquote@</a>} \
	     link_html { title "[_ evaluation-portlet.View_my_answer_]" }]
    
    set multirow_name grade_tasks
    set actions ""
}

set total_grade 0.00
set max_grade 0.00
set max_weight 0.00
set category_weight 0
set max_grade_label ""
set max_weight_label ""
set solution_label ""


template::list::create \
    -name grade_tasks \
    -multirow $multirow_name \
    -key task_id \
    -pass_properties { return_url mode base_url bottom_line max_grade_label max_weight_label solution_label submitted_label grade_of_label} \
    -filters { grade_id {} page_num {} } \
    -actions $bulk_actions \
    -no_data "[_ evaluation-portlet.No_assignments_]" \
    -elements $elements \
    -orderby_name evaluations_orderby \
    -main_class $class \
    -sub_class narrow \
    -orderby { default_value task_name }

set evaluations_orderby [template::list::orderby_clause -orderby -name grade_tasks]

if { [string equal $evaluations_orderby ""] } {
    set evaluations_orderby " order by task_name asc"
}

if { $admin_p } { 
    #admin
    db_multirow -extend { task_url grade_url audit_info audit_info_url task_points solution solution_url} grade_tasks_admin get_tasks_admin { *SQL* } {
	if { $simple_p } {
	    set task_url  [export_vars -base "${base_url}task-view" { grade_id task_id return_url }] 
	} else {
	    set task_url [export_vars -base "${base_url}admin/evaluations/student-list" { grade_id task_id return_url }] 
	}
	set category_weight [expr $category_weight + $task_weight]
	set grade_url  [export_vars -base "${base_url}admin/evaluations/student-list" { grade_id task_id return_url }] 
	set max_weight [format %0.2f [expr $max_weight + $task_weight]]
	set task_weight [format %0.2f $task_weight]
	set max_grade  [expr $max_grade + $perfect_score]
	set max_grade_label "<div style='text-align:center;'><text class=blue>$max_grade pts.</text></div>"
	set solution_label "[_ evaluation-portlet.weight_possible_of_grade_] <text class=blue>$low_name )</text>"
	
	if { $simple_p } {
	    set max_weight_label "<div style='text-align:center'><text class=blue>$max_weight %</text></div>"
	}
	if { [db_0or1row solution_info { *SQL* }] } { 
	    set solution_mode display
	    set solution_url "[export_vars -base "${base_url}admin/tasks/solution-add-edit" { grade_id task_id solution_id return_url solution_mode }]"
	    set solution "[_ evaluation-portlet.ViewEdit_Solution_]"
	} else {
	    set solution_mode edit
	    set solution_url "[export_vars -base "${base_url}admin/tasks/solution-add-edit" { grade_id task_id return_url solution_mode }]"
            if { $online_p } {
	        set solution "[_ evaluation-portlet.Upload_Solution_]"
            }
	}
	
	set task_points [format %0.2f [expr ($task_weight*$grade_weight)/100.0]]
	set audit_info_url [export_vars -base "${base_url}admin/evaluations/audit-info" { grade_id task_id }]
	
	set audit_info "[_ evaluation-portlet.Audit_Info_]"
	
    }
} else {
    
    db_multirow -extend { task_url submitted_date submitted_date_url comments comments_url grade_url answer answer_url grade task_grade} grade_tasks get_grade_tasks { *SQL* } {
	if { $simple_p } {
	    set task_url  [export_vars -base "${base_url}task-view" { grade_id task_id return_url }] 
	} else {
	    set task_url ""
	}
	set grade_url  [export_vars -base "${base_url}admin/evaluations/student-list" { grade_id task_id return_url }] 
	if { [db_0or1row get_evaluation_info { *SQL* }] } {
	    
	    if { ![empty_string_p $comments] } {
		set comments "[_ evaluation-portlet.View_comments_]"
		set comments_url "[export_vars -base "${base_url}evaluation-view" { evaluation_id return_url }]"
	    } else {
		set comments "[_ evaluation-portlet.lt_View_evaluation_detai]"
		set comments_url "[export_vars -base "${base_url}evaluation-view" { evaluation_id return_url }]"	    
	    }
	    

	    
	    set over_weight ""
	    if { [string eq $show_student_p "t"] } {
		if { ![empty_string_p $grade] } {
		    set grade [lc_numeric $grade]
		    set over_weight "[lc_numeric $task_grade]/"
		    if { $simple_p } {
			set task_grade [format %0.2f [expr ($grade*$perfect_score/100.0)]]
		    } 
		    set total_grade [expr $total_grade + $task_grade] 
		    if { $simple_p } {
			set max_grade [expr $task_grade + $max_grade] 
		    } else {
			set max_grade [expr $task_weight + $max_grade] 
		    }
		} else {
		    set grade "[_ evaluation-portlet.Not_evaluated_]"
		    set task_grade "[_ evaluation-portlet.Not_evaluated_]"
		}
		set task_weight "${over_weight}[lc_numeric $task_weight]"
		
	    } else {
		set grade "[_ evaluation-portlet.Not_available_]"
		set task_weight [lc_numeric $task_weight]
	    }
	} else {
	    set grade "[_ evaluation-portlet.Not_evaluated_]"
	    if { $simple_p } {
		set task_weight [lc_numeric $task_weight]
	    } else {
		set task_weight "[_ evaluation-portlet.Not_evaluated_]"
	    }
	    set task_grade "[_ evaluation-portlet.Not_evaluated_]"
	}	
	
	if { [db_0or1row get_answer_info { *SQL* }] } {
	    set submitted_date $creation_date
	    # working with answer stuff (if it has a file/url attached)
	    if { [string eq $answer_title "link"] } {
		# there is a bug in the template::list, if the url does not has a http://, ftp://, the url is not absolute,
		# so we have to deal with this case
		array set community_info [site_node::get -url "[dotlrn_community::get_community_url [dotlrn_community::get_community_id]][evaluation::package_key]"]
		if { ![regexp ([join [split [parameter::get -parameter urlProtocols -package_id $community_info(package_id)] ","] "|"]) "$answer_data"] } {
		    set answer_data "http://$answer_data"
		} 
		set answer_url "[export_vars -base "$answer_data" { }]"
		set answer "[_ evaluation-portlet.View_my_answer_]"
	    } else {
		# we assume it's a file
		set answer_url "[export_vars -base "${base_url}view/$answer_title" { {revision_id $answer_id} }]"
		set answer "[_ evaluation-portlet.View_my_answer_]"
	    }
	    
	    if { $number_of_members > 1 && [string eq [db_string get_group_id { *SQL* }] 0] } {
		set answer ""
		set answer_url ""
		set grade "[_ evaluation-portlet.No_group_for_task_]"
	    }
	} else {
	    set answer_url ""
	    set answer ""
	}
	set max_weight [expr $max_weight + $perfect_score]
	set max_grade_label "<div style='text-align:center'><text class=blue>$max_grade pts.</text></div>"
	set max_weight_label "<div style='text-align:center'><text class=blue>$max_weight %</text></div>"
	if { [empty_string_p $submitted_date]} {
	    
	    if { [string eq $online_p "t"] } {
		if { [db_string compare_due_date { *SQL* } -default 0] } {
		    if { ![db_0or1row answer_info { *SQL* }] } {
			set submitted_date "[_ evaluation-portlet.submit_answer_]"
			set submitted_date_mode edit
			set submitted_date_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id return_url answer_mode }]"
		    } else { 
			set submitted_date "[_ evaluation-portlet.submit_answer_again_]"
			set submitted_date_mode display
			set submitted_date_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id answer_id return_url answer_mode }]"
		    }
		} elseif { [string eq $late_submit_p "t"] } {
		    if { ![db_0or1row answer_info { *SQL* }] } {
			set submitted_date "[_ evaluation-portlet.lt_submit_answer_style_f]"
			set submitted_date_mode edit
			set submitted_date_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id return_url answer_mode }]"
		    } else {
			set submitted_date "[_ evaluation-portlet.lt_submit_answer_style_f_1]"
			set submitted_date_mode display
			set submitted_date_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id answer_id return_url answer_mode }]"
		    }
		}
		if { $number_of_members > 1 && [string eq [db_string get_group_id { *SQL* }] 0] } {
		    set submitted_date "[_ evaluation-portlet.No_group_for_task_]"
		    set submitted_date_url ""
		}
	    }
	} else {
	    set submitted_date_url "[export_vars -base "${base_url}answer-view" { grade_id task_id return_url answer_mode {answer_id}}]"
	    if { $number_of_members > 1 && [string eq [db_string get_group_id { *SQL* }] 0] } {
		
		set submitted_date "[_ evaluation-portlet.No_group_for_task_]"
		set submitted_date_url ""
	    }
	    
	}
    }
}

