# /packages/evaluation/www/admin/evaluations/grades-sheet-explanation.tcl

ad_page_contract {

	@author jopez@galileo.edu
    @creation-date May 2004
    @cvs-id $Id$

} {
	task_id:integer,notnull
}

set page_title "Grades Sheet Explanation"
set context [list [list "[export_vars -base student-list { task_id }]" "Studen List"] "Grades Sheet Explanation"]

ad_return_template
