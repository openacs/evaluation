# /packages/evaluation/www/admin/grades/grades-delete.tcl

ad_page_contract {

	Deletes a grade after confirmation

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$

} {
	grade_id:integer,notnull
	{return_url "index"}
}

set user_id [ad_verify_and_get_user_id]

set page_title "Delete Assignment Type"

set context [list [list "grades" "Assignment Types"] "Delete Assignment Type"]

db_1row get_grade_info "
    select item_id,
	grade_name
    from evaluation_gradesx
	where grade_id = :grade_id
"

set export_vars [export_form_vars grade_id return_url]

ad_return_template
