# /packages/evaluation/www/admin/grades/grades.tcl

ad_page_contract {

    List of grades and options to admin grades

    @author jopez@galileo.edu
    @creation-date Feb 2004
    @cvs-id $Id$

} -query {
    {orderby:optional}
}

set context [list "[_ evaluation.Grades_]"]
set package_id [ad_conn package_id]

set page_title "[_ evaluation.lt_Admin_Assignment_Type]"
set return_url [ad_conn url]

set actions [list "[_ evaluation.Add_assignment_type_]" [export_vars -base "grades-add-edit" { }]]

if { [lc_numeric %2.f [db_string sum_grades { *SQL* }]] > 100.00} {
    set aggregate_label "<span style=\"color: red;\">[_ evaluation.Total_]</span>"
} else {
    set aggregate_label "[_ evaluation.Total_]"
}

template::list::create \
    -name grades \
    -multirow grades \
    -actions $actions \
    -key grade_id \
    -pass_properties { return_url aggregate_label } \
    -elements {
        grade_plural_name {
            label "[_ evaluation.Name_]"
	    orderby_asc {grade_plural_name asc}
	    orderby_desc {grade_plural_name desc}
            link_url_eval {[export_vars -base "distribution-edit" { grade_id }]}
            link_html { title "View assignment type distribution" }
        }
        weight {
            label "[_ evaluation.lt_Weight_over_100_br__o]"
	    orderby_asc {weight asc}
	    orderby_desc {weight desc}
	    display_template { @grades.weight@% }
	    aggregate sum
	    aggregate_label { @aggregate_label;noquote@ }
        }
        comments {
            label "[_ evaluation.Description_]"
	    orderby_asc {comments asc}
	    orderby_desc {comments desc}
        }
	edit {
	    label {}
	    sub_class narrow
	    display_template {
		<img src="/resources/acs-subsite/Edit16.gif" width="16" height="16" border="0">
	    } 
	    link_url_eval {[export_vars -base "grades-add-edit" { item_id grade_id }]}
	    link_html { title "[_ evaluation.lt_Edit_assignment_type_]" }
	}
        delete {
            label {}
            sub_class narrow
            display_template {
                <img src="/resources/acs-subsite/Delete16.gif" width="16" height="16" border="0">
            } 
            link_url_eval {[export_vars -base "grades-delete" { grade_id return_url }]}
            link_html { title "[_ evaluation.lt_Delete_assignment_typ]" }
        }
    }

set orderby [template::list::orderby_clause -orderby -name grades]

if {[string equal $orderby ""]} {
    set orderby " order by grade_plural_name asc"
}

db_multirow grades get_class_grades { *SQL* } {
    set weight [lc_numeric %.2f $weight]
}

db_1row get_total_weight { *SQL* }

set total_weight [lc_numeric %.2f $total_weight]

if { ![string eq $total_weight "100.00"] && ![string eq $total_weight "0"] } {
    set notice "<span style=\"font-style: italic; color: red;\">[_ evaluation.lt_The_sum_of_the_weight]</span>"
} else {
    set notice ""
}

ad_return_template
