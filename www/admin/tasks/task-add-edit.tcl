# /packages/evaluation/www/admin/tasks/task-add-edit.tcl

ad_page_contract {
    Page for editing and adding tasks.

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    grade_id:integer,notnull
    task_id:integer,notnull,optional
    item_id:integer,notnull,optional
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
    {mode "edit"}
    return_url
    admin_groups_p:optional
    {add_to_more_classes_p ""}
    {attached_p "f"}
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set community_id [dotlrn_community::get_community_id]
set new_p [ad_form_new_p -key task_id] 
db_1row get_grade_info { *SQL* }
if { $new_p } {
    set page_title "[_ evaluation.Add_grade_name_]"
} else {
    set page_title "[_ evaluation.Edit_grade_name_]"
}

if { [info exists admin_groups_p] } {
    set div_visibility visible
    set checked_p checked
} else {
    set div_visibility hidden
    set checked_p ""
}

set context [list $page_title]

ad_form -html { enctype multipart/form-data } -name task -cancel_url $return_url -export { return_url item_id storage_type grade_id } -mode $mode -form {

    task_id:key

    {task_name:text  
	{label "[_ evaluation.Task_Name_]"}
	{html {size 30}}
    }
    
}

if { !$new_p } {

    db_1row get_task_info { *SQL* }
    
    if { [string eq $storage_type "lob"] } {

	if { [string eq $mode "edit"] } {
	    set attached_p "t"
	    
	    ad_form -extend -name task -form {			
		{upload_file:file,optional
		    {label "[_ evaluation.File_]"} 
		    {html "size 30"}
		    {help_text "[_ evaluation.lt_Currently_title_is_at_1]"}
		}
		{unattach_p:text(checkbox),optional 
		    {label "[_ evaluation.Unattach_file_]"} 
		    {options {{"" "t"}}}
		    {help_text "[_ evaluation.lt_Check_this_if_you_wan]"}
		}
		{url:text(text),optional
		    {label "[_ evaluation.URL__1]"} 
		    {value "http://"}
		}			
	    }
	} else {
	    ad_form -extend -name task -form {			
		{upload_file:text,optional
		    {label "[_ evaluation.File_]"} 
		    {html "size 30"}
		    {value "$title"}
		}
		{unattach_p:text(hidden)
		}
		{url:text(hidden)
		}			
	    }
	}
    } elseif { [string eq $title "link"] } {

	if { [string eq $mode "edit"] } {

	    set attached_p "t"
	    
	    ad_form -extend -name task -form {			
		
		{upload_file:file,optional
		    {label "[_ evaluation.File_]"} 
		    {html "size 30"}
		}
		{url:text(text),optional
		    {label "[_ evaluation.URL__1]"} 
		    {value "http://"}
		    {help_text "[_ evaluation.lt_Currently_content_is__1]"}
		}			
		{unattach_p:text(checkbox),optional 
		    {label "[_ evaluation.Unassociate_url_]"}
		    {options {{"" "t"}}} 
		    {help_text "[_ evaluation.lt_Check_this_if_you_wan]"}
		}
	    }
	} else {
	    ad_form -extend -name task -form {			
		
		{upload_file:text(hidden)
		}
		{url:text(text),optional
		    {label "[_ evaluation.URL__1]"} 
		    {value "$content"}
		}			
		{unattach_p:text(hidden)
		}
	    }
	}
    } else {
	ad_form -extend -name task -form {
	    
	    {upload_file:file,optional
		{label "[_ evaluation.File_]"} 
		{html "size 30"}
		{help_text "[_ evaluation.lt_You_can_upload_a_file]"}
	    }
	    
	    {url:text(text),optional
		{label "[_ evaluation.URL__1]"} 
		{value "http://"}
		{help_text "You can associate a link to this task by entering the absolute url here (also optional)"}
	    }
	    
	    {unattach_p:text(hidden),optional
		{value ""}
	    }
	}
	
    }
} else {
    
    ad_form -extend -name task -form {
	
	{upload_file:file,optional
	    {label "[_ evaluation.File_]"} 
	    {html "size 30"}
	    {help_text "[_ evaluation.lt_You_can_upload_a_file_1]"}
	}
    }

    ad_form -extend -name task -form {
	
	{url:text(text),optional
	    {label "[_ evaluation.URL__1]"} 
	    {value "http://"}
	    {help_text "[_ evaluation.lt_You_can_associate_a_l]"}
	}
	
	{unattach_p:text(hidden),optional
	    {value ""}
	}
    }
}

ad_form -extend -name task -form {

    {description:richtext,optional  
	{label "[_ evaluation.lt_Assignments_Descripti]"}
	{html {rows 4 cols 40 wrap soft}}
    }

    {due_date:date,to_sql(linear_date),from_sql(sql_date)
	{label "[_ evaluation.Due_Date_]"}
	{format "MONTH DD YYYY HH24 MI SS"}
	{today}
	{help}
	{value {[evaluation::now_plus_days -ndays 15]}}
    }

    {number_of_members:naturalnum
	{label "[_ evaluation.Number_of_Members_]"}
	{value "1"}
	{html {size 5 onChange TaskInGroups()}}
	{help_text "[_ evaluation.1__Individual_]"}
	{after_html {<div id="silentDiv" style="visibility:$div_visibility;"><div class="form-help-text"><input type="checkbox" name="admin_groups_p" $checked_p> [_ evaluation.lt_Check_this_if_you_wan_1] </div></div>}}
    }

    {weight:float,optional
	{label "[_ evaluation.lt_Weight_over_grade_wei_2]"}
	{html {size 5}} 
	{help_text "[_ evaluation.lt_You_can_enter_the_wei]"}
	{value "0"}
    }

    {net_value:float,optional
	{label "[_ evaluation.Net_Value_]"}
	{html {size 5}}
	{help_text "[_ evaluation.lt_If_you_enter_the_net_]"}
	{value "0"}
    }
    
    {online_p:text(radio)     
	{label "[_ evaluation.lt_Will_the_task_be_subm]"} 
	{options {{"[_ evaluation.Yes_]" t} {"[_ evaluation.No_]" f}}}
	{value t}
    }

    {late_submit_p:text(radio)     
	{label "[_ evaluation.lt_Can_the_student_submi]"} 
	{options {{"[_ evaluation.Yes_]" t} {"[_ evaluation.No_]" f}}}
	{value t}
    }

    {requires_grade_p:text(radio)     
	{label "[_ evaluation.lt_Will_this_task_requir]"} 
	{options {{"[_ evaluation.Yes_]" t} {"[_ evaluation.No_]" f}}}
	{value t}
    }
}

if { $new_p && ![empty_string_p $community_id] && [db_string get_user_comunities { *SQL* }] } {
    ad_form -extend -name task -form {
	{add_to_more_classes_p:text(checkbox),optional 
	    {label "[_ evaluation.lt_Add_this_assignment_t]"} 
	    {options {{"" "t"}}}
	    {help_text "[_ evaluation.lt_Check_this_if_you_wan_2]"}
	}
    }
} 

ad_form -extend -name task -form {

} -edit_request {
    
    db_1row task_info { *SQL* }

    set due_date [template::util::date::from_ansi $due_date_ansi "YYYY-MM-DD HH24:MI:SS"]
    set weight [format %.2f [lc_numeric $weight]]

} -validate {
    {url
	{ ([string eq $url "http://"] && ![empty_string_p $upload_file]) || (![string eq $url "http://"] && [empty_string_p $upload_file]) || ([string eq $url "http://"] && [empty_string_p $upload_file]) || (![string eq $url "http://"] && [util_url_valid_p $url]) }
	{[_ evaluation.lt_Upload_a_file_OR_a_ur_1] }
    }
    {upload_file
	{ ([string eq $url "http://"] && ![empty_string_p $upload_file]) || (![string eq $url "http://"] && [empty_string_p $upload_file]) || ([string eq $url "http://"] && [empty_string_p $upload_file]) }
	{ [_ evaluation.lt_Upload_a_file_OR_a_ur_1] }
    }
    {unattach_p 
	{ ([string eq $unattach_p "t"] && [empty_string_p $upload_file] && [string eq $url "http://"]) || [empty_string_p $unattach_p] }
	{ [_ evaluation.lt_First_unattach_the_fi] }
    }
    {net_value 
	{ [string eq [format %.2f $net_value] 0.00] || ([empty_string_p $net_value] && [string eq $requires_grade_p f]) || (($net_value > 0) && ($net_value <= $grade_weight) && ([string eq [format %.2f $weight] 0.00] || [empty_string_p $weight])) }
	{ [_ evaluation.lt_The_net_value_must_be] }
    }
    {weight
	{ [string eq [format %.2f $weight] 0.00] || ([empty_string_p $weight] && [string eq $requires_grade_p f]) || (($weight > 0) && ([string eq [format %.2f $net_value] 0.00] || [empty_string_p $net_value])) }
	{ [_ evaluation.lt_The_weight_must_be_gr] }
    }
} -new_data {
    
    evaluation::notification::do_notification -task_id $revision_id -package_id [ad_conn package_id] -edit_p 0 -notif_type one_assignment_notif
    
} -edit_data {

    evaluation::notification::do_notification -task_id $revision_id -package_id [ad_conn package_id] -edit_p 1 -notif_type one_assignment_notif

} -on_submit {
    
    if { [string eq $requires_grade_p t] } {
	if { [info exists net_value] && ($net_value > 0) } {
	    set weight [expr $net_value*100.000/$grade_weight]
	}
    } else {
	set weight 0
    }

    db_transaction {
		
	if { ![empty_string_p $upload_file] } {
	    
	    # Get the filename part of the upload file
	    if { ![regexp {[^//\\]+$} $upload_file filename] } {
		# no match
		set filename $upload_file
	    }
	    
	    set title [template::util::file::get_property filename $upload_file]
	    set mime_type [cr_filename_to_mime_type -create $title]
	    
	    set storage_type lob
	} elseif { ![string eq $url "http://"] } {
	    set mime_type "text/plain"
	    set title "link"
	    set storage_type text
	} elseif { [string eq $attached_p "f"] } {
	    set mime_type "text/plain"
	    set title ""
	    set storage_type text
	}
	
	set title [evaluation::safe_url_name -name $title]
	set due_date [db_string set_date { *SQL* }]
	
	if { [ad_form_new_p -key task_id] } {
	    set item_id $task_id
	} 

	set revision_id [evaluation::new_task -new_item_p [ad_form_new_p -key grade_id] -item_id $item_id -content_type evaluation_tasks \
			     -content_table evaluation_tasks -content_id task_id -name $task_name -description $description -weight $weight \
			     -grade_item_id $grade_item_id -number_of_members $number_of_members -online_p $online_p -storage_type $storage_type \
			     -due_date  $due_date -late_submit_p $late_submit_p -requires_grade_p $requires_grade_p -title $title \
			     -mime_type $mime_type]
	
	evaluation::set_live -revision_id $revision_id

	if { ![empty_string_p $upload_file] }  {
	    
	    set tmp_file [template::util::file::get_property tmp_filename $upload_file]
	    
	    # create the new item
	    db_dml lob_content { *SQL* } -blob_files [list $tmp_file]
	    
	    set content_length [file size $tmp_file]
	    # Unfortunately, we can only calculate the file size after the lob is uploaded 
	    db_dml lob_size { *SQL* }
	    
	} elseif { ![string eq $url "http://"] } {
	    
	    db_dml link_content { *SQL* }
	    set content_length [string length $url]
	    db_dml lob_size { *SQL* }
	    
	} elseif { [string eq $attached_p "t"] && ![string eq $unattach_p "t"] } {

	    # just copy the old content to the new revision
	    db_exec_plsql copy_content { *SQL* }
	}	
    }
} -after_submit {
    set redirect_to_groups_p 0
    if { [info exists admin_groups_p] && $number_of_members > 1 } {
	set redirect_to_groups_p 1
    }
    if { ![empty_string_p $add_to_more_classes_p] } {
	ad_returnredirect [export_vars -base "task-add-to-communities" { redirect_to_groups_p {task_id $revision_id} return_url }]
    } elseif { $redirect_to_groups_p } {
	ad_returnredirect [export_vars -base "../groups/one-task" { {task_id $revision_id} }]
	ad_script_abort
    } else {
	ad_returnredirect "$return_url"
	ad_script_abort
    }
} 

ad_return_template
