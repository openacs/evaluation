# /packages/evaluation/www/admin/grades/grades-delete.tcl

ad_page_contract {

	Deletes a grade after confirmation

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$

} {
	grade_id:naturalnum,notnull
	{return_url "index"}
}

set user_id [ad_conn user_id]

set page_title "[_ evaluation.lt_Delete_Assignment_Typ]"

set context [list [list "grades" "[_ evaluation.Assignment_Types_]"] "[_ evaluation.lt_Delete_Assignment_Typ]"]

db_1row get_grade_info { *SQL* }

set export_vars [export_vars -form -- {grade_id return_url}]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
