# /packages/evaluation/www/admin/grades/grades-add-edit.tcl

ad_page_contract {
    Page for editing and adding grades.

    @author jopez@galileo.edu
    @creation-date Feb 2004
    @cvs-id $Id$
} {
	grade_id:integer,notnull,optional
	item_id:integer,notnull,optional
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]

if { [ad_form_new_p -key grade_id] } {
	set page_title "Add Assignment Type"
} else {
	set page_title "Edit Assignment Type"
}

set context [list [list [export_vars -base grades { }] "Assignment Types"] $page_title]

ad_form -name grade -cancel_url [export_vars -base grades { }] -export { } -form {

	grade_id:key

	{grade_name:text  
		{label "Assignment Type Name"}
		{html {size 30}}
	}

	{grade_plural_name:text  
		{label "Assignment Plural Type Name"}
		{html {size 30}}
	}
	
	{weight:float
		{label "Weight"}
		{html {size 5}}
	}

	{comments:text(textarea),optional  
		{label "Assignment Type's Comments"}
		{html {rows 4 cols 40}}
	}
	
} -edit_request {
	
	db_1row get_grade_info { *SQL* }

	set grade_id $item_id

} -validate {
	{weight
		{ ($weight >= 0) && ($weight <= 100) }
		{Weight must be a real number and between 0 and 100}
	}

} -on_submit {
	
	db_transaction {
		
		set revision_id [evaluation::new_grade -new_item_p [ad_form_new_p -key grade_id] -item_id $grade_id -content_type evaluation_grades \
							 -content_table evaluation_grades -content_id grade_id -name $grade_name -plural_name $grade_plural_name -description $comments -weight $weight]
		
		evaluation::set_live -revision_id $revision_id
		
	}
	
	ad_returnredirect "grades"
	ad_script_abort
}

ad_return_template
