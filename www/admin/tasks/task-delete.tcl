ad_page_contract {

	Deletes a task after confirmation

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$

} {
	task_id:integer,notnull
	grade_id:integer,notnull
	return_url
}

set page_title "[_ evaluation.Delete_Task_]"

set context [list [list [export_vars -base ../grades/grades { }] "[_ evaluation.Grades_]"] $page_title]


db_1row get_task_info { *SQL* }

set export_vars [export_form_vars task_id grade_id return_url]

ad_return_template
