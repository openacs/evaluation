# /packages/evaluation/www/admin/tasks/solution-add-edit.tcl

ad_page_contract {
    Page for editing and adding task solutions.

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    task_id:integer,notnull
    solution_id:integer,notnull,optional
    item_id:integer,notnull,optional
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
    {solution_mode "edit"}
    grade_id:integer,notnull
    return_url
}

set package_id [ad_conn package_id]

if { [ad_form_new_p -key solution_id] } {
	set page_title "[_ evaluation.Add_Task_Solution_]"
} else {
	set page_title "[_ evaluation.lt_ViewEdit_Task_Solutio]"
}

set context [list [list [export_vars -base ../grades/grades { }] "[_ evaluation.Grades_]"] $page_title]

set attached_p "f"
ad_form -html { enctype multipart/form-data } -name solution -cancel_url $return_url -export { return_url grade_id item_id storage_type task_id attached_p } -mode $solution_mode -form {

	solution_id:key

}

if { ![ad_form_new_p -key solution_id] } {

	db_1row get_sol_info { *SQL* }
	
	if { [string eq $storage_type "lob"] } {

		if { [string eq $solution_mode "edit"] } {
			set attached_p "t"
			
			ad_form -extend -name solution -form {			
				{upload_file:file,optional
					{label "[_ evaluation.File_]"} 
					{html "size 30"}
					{help_text "[_ evaluation.lt_Currently_title_is_at]"}
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
			ad_form -extend -name solution -form {			
				{upload_file:text,optional
					{label "[_ evaluation.File_]"} 
					{html "size 30"}
					{value "[return $title]"}
				    {after_html "<a href=\"[export_vars -base \"../../view/$title\" { revision_id }]\">$title</a>"}
				}
				{unattach_p:text(hidden)
				}
				{url:text(hidden)
				}			
			}
		}
	} elseif { [regexp "http://" $content] } {

		if { [string eq $solution_mode "edit"] } {

			set attached_p "t"
			
			ad_form -extend -name solution -form {			
				
				{upload_file:file,optional
					{label "[_ evaluation.File_]"} 
					{html "size 30"}
				}
				{url:text(text),optional
					{label "[_ evaluation.URL__1]"} 
					{value "http://"}
					{help_text "[_ evaluation.lt_Currently_content_is_]"}
				}			
				{unattach_p:text(checkbox),optional 
					{label "[_ evaluation.Unassociate_url_]"}
					{options {{"" "t"}}} 
					{help_text "[_ evaluation.lt_Check_this_if_you_wan]"}
				}
			}
		} else {
			ad_form -extend -name solution -form {			
				
				{upload_file:text(hidden)
				}
				{url:text(text),optional
					{label "[_ evaluation.URL__1]"} 
					{value "$content"}
					{after_html "<a href=$content>$content</a>"}
				}			
				{unattach_p:text(hidden)
				}
			}
		}
	} else {
		ad_form -extend -name solution -form {
			
			{upload_file:file,optional
				{label "[_ evaluation.File_]"} 
				{html "size 30"}
			}
			{url:text(text),optional
				{label "[_ evaluation.URL__1]"} 
				{value "http://"}
			}
			{unattach_p:text(hidden),optional
				{value ""}
			}
		}
	}
} else {
	
	ad_form -extend -name solution -form {
		
		{upload_file:file,optional
			{label "[_ evaluation.File_]"} 
			{html "size 30"}
		}
		{url:text(text),optional
			{label "[_ evaluation.URL__1]"} 
			{value "http://"}
		}
		{unattach_p:text(hidden),optional
			{value ""}
		}
	}
}

ad_form -extend -name solution -form {

} -edit_request {
	
	db_1row solution_info { *SQL* }

} -validate {
	{url
		{ ([string eq $url "http://"] && ![empty_string_p $upload_file]) || (![string eq $url "http://"] && [empty_string_p $upload_file]) || (![string eq $url "http://"] && [util_url_valid_p $url]) || ([string eq $url "http://"] && [empty_string_p $upload_file] && [string eq $unattach_p "t"]) }
		{ [_ evaluation.lt_Upload_a_file_OR_a_va] }
	}
	{upload_file
		{ ([string eq $url "http://"] && ![empty_string_p $upload_file]) || (![string eq $url "http://"] && [empty_string_p $upload_file]) || ([string eq $url "http://"] && [empty_string_p $upload_file] && [string eq $unattach_p "t"]) }
		{ [_ evaluation.lt_Upload_a_file_OR_a_ur] }
	}
	{unattach_p 
		{ ([string eq $unattach_p "t"] && [empty_string_p $upload_file] && [string eq $url "http://"]) || [empty_string_p $unattach_p] }
		{ [_ evaluation.lt_First_unattach_the_fi] }
	}
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
		}  elseif { ![string eq $url "http://"] } {
			set mime_type "text/plain"
			set title "link"
			set storage_type text
		}
		
		set title [evaluation::safe_url_name -name $title]
		if { [ad_form_new_p -key solution_id] } {
			set item_id $solution_id
		} 

		set revision_id [evaluation::new_solution -new_item_p [ad_form_new_p -key solution_id] -item_id $item_id -content_type evaluation_tasks_sols \
							 -content_table evaluation_tasks_sols -content_id solution_id -storage_type $storage_type -task_id $task_id \
							 -title $title -mime_type $mime_type]
		
		evaluation::set_live -revision_id $revision_id

		if { ![empty_string_p $upload_file] }  {

			set tmp_file [template::util::file::get_property tmp_filename $upload_file]
			
			# create the new item
			db_dml lob_content { *SQL* } -blob_files [list $tmp_file]

		} elseif { ![string eq $url "http://"] } {
			
			db_dml link_content { *SQL* }
			
		} elseif { [string eq $attached_p "t"] && ![string eq $unattach_p "t"] } {
			# just copy the old content to the new revision
			db_exec_plsql copy_content { *SQL* }
		} elseif { [string eq $unattach_p "t"] } {
			db_dml unassociate_task_sol { *SQL* }
		} 
	}
 
 	ad_returnredirect "$return_url"
 	ad_script_abort
}

ad_return_template
