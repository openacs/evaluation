# /packages/evaluation/www/answer-add-edit.tcl

ad_page_contract {
    Page for editing and adding answers.

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    task_id:integer,notnull
    grade_id:integer,notnull
    answer_id:integer,notnull,optional
    item_id:integer,notnull,optional
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
    return_url:notnull
} -validate {
    late_submit {
	if { ![db_string late_turn_in { *SQL* }] && ([template::util::date::compare [db_string due_date "select due_date from evaluation_tasks where task_id = :task_id"] [template::util::date::now]] < 0) } {
	    ad_complain "[_ evaluation.lt_This_task_can_not_be_]"
	}
    }
}

set user_id [ad_conn user_id]
set party_id [db_string get_party_id { *SQL* }]

set package_id [ad_conn package_id]

if { [ad_form_new_p -key answer_id] } {
	set page_title "[_ evaluation.Upload_Answer_]"
} else {
	set page_title "[_ evaluation.Change_Answer_]"
	db_1row item_data { *SQL* }

}

set context [list $page_title]

ad_form -html { enctype multipart/form-data } -name answer -cancel_url $return_url -export { item_id grade_id task_id attached_p return_url } -form {

	answer_id:key

}

ad_form -extend -name answer -form {
	
	{upload_file:file,optional
		{label "[_ evaluation.File_]"} 
		{html "size 30"}
	}
	{url:text(text),optional
		{label "[_ evaluation.URL__1]"} 
		{value "http://"}
	}
}

ad_form -extend -name answer -form {

} -edit_request {
	
	db_1row item_data { *SQL* }

} -validate {
    {url
	{ ([string eq $url "http://"] && ![empty_string_p $upload_file]) || (![string eq $url "http://"] && [empty_string_p $upload_file]) || (![string eq $url "http://"] && [util_url_valid_p $url]) }
	{ [_ evaluation.lt_Upload_a_file_OR_a_va] }
    }
    {upload_file
	{ ([string eq $url "http://"] && ![empty_string_p $upload_file]) || (![string eq $url "http://"] && [empty_string_p $upload_file]) }
	{ [_ evaluation.lt_Upload_a_file_OR_a_ur] }
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
		if { [ad_form_new_p -key answer_id] } {
			set item_id $answer_id
		} 

		set revision_id [evaluation::new_answer -new_item_p [ad_form_new_p -key answer_id] -item_id $item_id -content_type evaluation_answers \
							 -content_table evaluation_answers -content_id answer_id -storage_type $storage_type -task_id $task_id \
							 -title $title -mime_type $mime_type -party_id $party_id]
		
		evaluation::set_live -revision_id $revision_id

		if { ![empty_string_p $upload_file] }  {

			set tmp_file [template::util::file::get_property tmp_filename $upload_file]
			
			# create the new item
			db_dml lob_content { *SQL* } -blob_files [list $tmp_file]

		} elseif { ![string eq $url "http://"] } {
			
			db_dml link_content { *SQL* }
			
		}
	}
 
 	ad_returnredirect "$return_url"
 	ad_script_abort
}

ad_return_template