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
	if { ([template::util::date::compare [db_string due_date "select due_date from evaluation_tasks where task_id = :task_id"] [template::util::date::now]] < 0) } {
	    ad_complain "tarde manin"
	}
    }
}

set user_id [ad_conn user_id]
set party_id [db_string get_party_id { *SQL* }]

set package_id [ad_conn package_id]

if { [ad_form_new_p -key answer_id] } {
	set page_title "Upload Answer"
} else {
	set page_title "Change Answer"
	db_1row item_data { *SQL* }

}

set context [list $page_title]

ad_form -html { enctype multipart/form-data } -name answer -cancel_url $return_url -export { item_id grade_id task_id attached_p return_url } -form {

	answer_id:key

}

ad_form -extend -name answer -form {
	
	{upload_file:file,optional
		{label "File"} 
		{html "size 30"}
	}
	{url:text(text),optional
		{label "URL"} 
		{value "http://"}
	}
}

ad_form -extend -name answer -form {

} -edit_request {
	
	db_1row item_data { *SQL* }

} -validate {
    {url
	{ ([string eq $url "http://"] && ![empty_string_p $upload_file]) || (![string eq $url "http://"] && [empty_string_p $upload_file]) || (![string eq $url "http://"] && [util_url_valid_p $url]) }
	{Upload a file OR a valid url, and not both }
    }
    {upload_file
	{ ([string eq $url "http://"] && ![empty_string_p $upload_file]) || (![string eq $url "http://"] && [empty_string_p $upload_file]) }
	{Upload a file OR a url, and not both}
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
