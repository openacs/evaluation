# /packages/evaluation/www/admin/grades/grades.tcl

ad_page_contract {

    List of grades and options to admin grades

    @author jopez@galileo.edu
    @creation-date Feb 2004
    @cvs-id $Id$

} -query {
    {orderby:optional}
}

set context [list Grades]
set package_id [ad_conn package_id]

set page_title "Admin Assignment Types"
set return_url [ad_conn url]

set actions [list "Add assignment type" [export_vars -base "grades-add-edit" { }]]

if { [format %2.f [db_string sum_grades { *SQL* }]] > 100.00} {
    set aggregate_label "<span style=\"color: red;\">Total</span>"
} else {
    set aggregate_label "Total"
}

template::list::create \
    -name grades \
    -multirow grades \
    -actions $actions \
    -key grade_id \
    -pass_properties { return_url aggregate_label } \
    -elements {
        grade_plural_name {
            label "Name"
	    orderby_asc {grade_plural_name asc}
	    orderby_desc {grade_plural_name desc}
            link_url_eval {[export_vars -base "distribution-edit" { grade_id }]}
            link_html { title "View assignment type distribution" }
        }
        weight {
            label "Weight"
	    orderby_asc {weight asc}
	    orderby_desc {weight desc}
	    display_template { @grades.weight@% }
	    aggregate sum
	    aggregate_label { @aggregate_label;noquote@ }
        }
        comments {
            label "Description"
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
            link_html { title "Edit assignment type" }
        }
        delete {
            label {}
            sub_class narrow
            display_template {
                <img src="/resources/acs-subsite/Delete16.gif" width="16" height="16" border="0">
            } 
            link_url_eval {[export_vars -base "grades-delete" { grade_id return_url }]}
            link_html { title "Delete assignment type" }
        }
    }

set orderby [template::list::orderby_clause -orderby -name grades]

if {[string equal $orderby ""]} {
    set orderby " order by grade_plural_name asc"
}

db_multirow grades get_class_grades { *SQL* } 

db_1row get_total_weight { *SQL* }

set total_weight [format %.2f $total_weight]

if { ![string eq $total_weight "100.00"] && ![string eq $total_weight "0"] } {
    set notice "<span style=\"font-style: italic; color: red;\">The sum of the weight of all the assignment types is $total_weight and it should be 100.00 by the end of the term(supposedly).</span>"
} else {
    set notice ""
}

ad_return_template
