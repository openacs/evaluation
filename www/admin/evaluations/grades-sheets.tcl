# /packages/evaluation/www/admin/evaluations/grades-sheets.tcl

ad_page_contract {

	List the grades sheets for the task

    @author jopez@galileo.edu
    @creation-date May 2004
    @cvs-id $Id$

} -query {
	{orderby:optional}
	task_id:integer,notnull
} -validate {
	grades_sheets {
		if { ![db_string count_grades_sheets { *SQL* }] } {
			ad_complain "There are no files associated with this task"
		}
	}
}


set page_title "Grades Sheets"
set context [list [list "[export_vars -base student-list { task_id }]" "Studen List"] "Grades Sheets"]

set base_url [ad_conn package_url]

template::list::create \
    -name grades_sheets \
    -multirow grades_sheets \
	-key grades_sheet_id \
	-filters { task_id {} } \
	-orderby { default_value grades_sheet_name } \
    -elements {
        grades_sheet_name {
            label "Grades Sheet Name"
			orderby_asc {grades_sheet_name asc}
			orderby_desc {grades_sheet_name desc}
        }
        upload_date {
            label "Upload Date"
			orderby_asc {upload_date asc}
			orderby_desc {upload_date desc}
        }
        upload_user {
            label "Uploaded by"
			orderby_asc {upload_user asc}
			orderby_desc {upload_user desc}
        }
        view {
            label {}
            sub_class narrow
            display_template {
                <img src="/resources/acs-subsite/Zoom16.gif" width="16" height="16" border="0">
            } 
            link_url_col view_url
            link_html { title "View grades sheet" }
        }
    }

set orderby [template::list::orderby_clause -orderby -name grades_sheets]

if {[string equal $orderby ""]} {
    set orderby " order by grades_sheet_name asc"
}

db_multirow -extend { view_url } grades_sheets get_grades_sheets { *SQL* } {
	set view_url "[export_vars -base "${base_url}view/$grades_sheet_name" { revision_id }]"
}

ad_return_template
