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
}

set package_id [ad_conn package_id]

set community_id [dotlrn_community::get_community_id]
set new_p [ad_form_new_p -key task_id] 
if { $new_p } {
    set page_title "Add Task"
} else {
    set page_title "Edit Task"
}

if { [info exists admin_groups_p] } {
    set div_visibility visible
    set checked_p checked
} else {
    set div_visibility hidden
    set checked_p ""
}

db_1row get_grade_info { *SQL* }

set context [list $page_title]

set attached_p "f"
ad_form -html { enctype multipart/form-data } -name task -cancel_url $return_url -export { return_url item_id storage_type grade_id attached_p } -mode $mode -form {

    task_id:key

    {task_name:text  
	{label "Task Name"}
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
		    {label "File"} 
		    {html "size 30"}
		    {help_text "Currently $title is attached to this task, but you can attach a different file/url just by adding it here"}
		}
		{unattach_p:text(checkbox),optional 
		    {label "Unattach file?"} 
		    {options {{"" "t"}}}
		    {help_text "Check this if you want to unattach the file"}
		}
		{url:text(text),optional
		    {label "URL"} 
		    {value "http://"}
		}			
	    }
	} else {
	    ad_form -extend -name task -form {			
		{upload_file:text,optional
		    {label "File"} 
		    {html "size 30"}
		    {value "$title"}
		}
		{unattach_p:text(hidden)
		}
		{url:text(hidden)
		}			
	    }
	}
    } elseif { [regexp "http://" $content] } {

	if { [string eq $mode "edit"] } {

	    set attached_p "t"
	    
	    ad_form -extend -name task -form {			
		
		{upload_file:file,optional
		    {label "File"} 
		    {html "size 30"}
		}
		{url:text(text),optional
		    {label "URL"} 
		    {value "http://"}
		    {help_text "Currently $content is associated to this task, but you can associate a different url/file just by adding it here"}
		}			
		{unattach_p:text(checkbox),optional 
		    {label "Unassociate url?"}
		    {options {{"" "t"}}} 
		    {help_text "Check this if you want to unattach the file"}
		}
	    }
	} else {
	    ad_form -extend -name task -form {			
		
		{upload_file:hidden
		}
		{url:text(text),optional
		    {label "URL"} 
		    {value "$content"}
		}			
		{unattach_p:text(hidden)
		}
	    }
	}
    } else {
	ad_form -extend -name task -form {
	    
	    {upload_file:file,optional
		{label "File"} 
		{html "size 30"}
		{help_text "You can upload a file associated to this task by using the browse button (optional)"}
	    }
	    
	    {url:text(text),optional
		{label "URL"} 
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
	    {label "File"} 
	    {html "size 30"}
	    {help_text "You can upload a file associated to this task by using the browse button and select the file from your computer (optional)"}
	}
    }

    ad_form -extend -name task -form {
	
	{url:text(text),optional
	    {label "URL"} 
	    {value "http://"}
	    {help_text "You can associate a link to this task by entering the absolute url here (also optional)"}
	}
	
	{unattach_p:text(hidden),optional
	    {value ""}
	}
    }
}

ad_form -extend -name task -form {

    {description:richtext,optional  
	{label "Task's Description"}
	{html {rows 4 cols 40 wrap soft}}
    }

    {due_date:date,to_sql(linear_date),from_sql(sql_date)
	{label "Due Date"}
	{format "MONTH DD YYYY"}
	{today}
	{help}
	{value {[evaluation::now_plus_days -ndays 15]}}
    }

    {number_of_members:naturalnum
	{label "Number of Members"}
	{value "1"}
	{html {size 5 onChange TaskInGroups()}}
	{help_text "1 = Individual"}
	{after_html {<div id="silentDiv" style="visibility:$div_visibility;"><div class="form-help-text"><input type="checkbox" name="admin_groups_p" $checked_p> Check this if you want to go to the groups admin page after submitting the task </div></div>}}
    }

    {weight:float  
	{label "Weight"}
	{html {size 5}}
	{help_text "over $grade_weight% of $grade_plural_name"}
    }
    
    {online_p:text(radio)     
	{label "Will the task be submitted online?"} 
	{options {{Yes t} {No f}}}
	{value t}
    }

    {late_submit_p:text(radio)     
	{label "Can the student submit the answer <br> after the due date?"} 
	{options {{Yes t} {"No" f}}}
	{value t}
    }

    {requires_grade_p:text(radio)     
	{label "Will this task require a grade on the course?"} 
	{options {{Yes t} {"No" f}}}
	{value t}
    }
}

if { $new_p && ![empty_string_p $community_id] } {
    ad_form -extend -name task -form {
	{add_to_more_classes_p:text(checkbox),optional 
	    {label "Add this assignment to other class(es)"} 
	    {options {{"" "t"}}}
	    {help_text "Check this if you want to add the assignment to other class(es) that you administer"}
	}
    }
} 

ad_form -extend -name task -form {

} -edit_request {
    
    db_1row task_info { *SQL* }

    set due_date [template::util::date::from_ansi $due_date]

} -validate {
    {due_date
	{ [template::util::date::compare $due_date [template::util::date::now]] > 0 }
	{Due date must be in the future}
    }
    {url
	{ ([string eq $url "http://"] && ![empty_string_p $upload_file]) || (![string eq $url "http://"] && [empty_string_p $upload_file]) || ([string eq $url "http://"] && [empty_string_p $upload_file]) || (![string eq $url "http://"] && [util_url_valid_p $url]) }
	{Upload a file OR a url, not both}
    }
    {upload_file
	{ ([string eq $url "http://"] && ![empty_string_p $upload_file]) || (![string eq $url "http://"] && [empty_string_p $upload_file]) || ([string eq $url "http://"] && [empty_string_p $upload_file]) }
	{Upload a file OR a url, not both}
    }
    {unattach_p 
	{ ([string eq $unattach_p "t"] && [empty_string_p $upload_file] && [string eq $url "http://"]) || [empty_string_p $unattach_p] }
	{First unattach the file/url, then submit another one or just upload a new file/url and leave this in blank}
    }
} -new_data {
    
    evaluation::notification::do_notification -task_id $revision_id -package_id [ad_conn package_id] -edit_p 0 -notif_type one_assignment_notif
    
} -edit_data {

    evaluation::notification::do_notification -task_id $revision_id -package_id [ad_conn package_id] -edit_p 1 -notif_type one_assignment_notif

} -on_submit {
    
    db_transaction {
	
	set mime_type "text/plain"
	set title ""
	set storage_type text
	
	if { ![empty_string_p $upload_file] } {
	    
	    # Get the filename part of the upload file
	    if { ![regexp {[^//\\]+$} $upload_file filename] } {
		# no match
		set filename $upload_file
	    }
	    
	    set title [template::util::file::get_property filename $upload_file]
	    set mime_type [cr_filename_to_mime_type -create $title]
	    
	    set storage_type lob
	} 
	
	set due_date [db_string set_date { *SQL* }]
	
	if { [ad_form_new_p -key task_id] } {
	    set item_id $task_id
	} 

	set revision_id [evaluation::new_task -new_item_p [ad_form_new_p -key grade_id] -item_id $item_id -content_type evaluation_tasks \
			     -content_table evaluation_tasks -content_id task_id -name $task_name -description $description -weight $weight \
			     -grade_id $grade_id -number_of_members $number_of_members -online_p $online_p -storage_type $storage_type \
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
