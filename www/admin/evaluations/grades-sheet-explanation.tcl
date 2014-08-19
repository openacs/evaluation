# /packages/evaluation/www/admin/evaluations/grades-sheet-explanation.tcl

ad_page_contract {

	@author jopez@galileo.edu
    @creation-date May 2004
    @cvs-id $Id$

} {
	task_id:naturalnum,notnull
}

set page_title "[_ evaluation.lt_Grades_Sheet_Explanat]"
set context [list [list "[export_vars -base student-list { task_id }]" "[_ evaluation.Studen_List_]"] "[_ evaluation.lt_Grades_Sheet_Explanat]"]

ad_return_template
