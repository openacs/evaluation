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
set simple_p [parameter::get -parameter "SimpleVersion"]
set class "list"
set aggregate ""
set bulk_actions [list "[_ evaluation.Add_assignment_type_]" [export_vars -base "grades-add-edit" { }]]

set page_title "[_ evaluation.lt_Admin_Assignment_Type]"
set return_url [ad_conn url]
set total 0
set a_label [_ evaluation.total_of_course]
set actions "<a href=[export_vars -base "grades-add-edit" { }] class=\"tlmidnav\"><img src=\"/resources/evaluation/cross.gif\" width=\"10\" height=\"9\" hspace=\"5\" vspace=\"1\" border=\"0\" align=\"absmiddle\">[_ evaluation.Add_assignment_type_]</a>"

if { [lc_numeric %2.f [db_string sum_grades { *SQL* }]] > 100.00} {
    set aggregate_label "<span style=\"color: red;\">[_ evaluation.Total_d]</span>"
} else {
    set aggregate_label "[_ evaluation.Total_d]"
}

if { !$simple_p } {
    set aggregate_label ""
    set aggregate "sum"
    set total "Total"
    set a_label ""
} else {
    set class "pbs_list"
    set bulk_actions ""
}


template::list::create \
    -name grades \
    -multirow grades \
    -key grade_id \
    -actions $bulk_actions  \
    -main_class $class \
    -sub_class narrow \
    -pass_properties { return_url aggregate_label total a_label aggregate} \
    -elements {
        grade_plural_name {
            label "[_ evaluation.name]"
	    orderby_asc {grade_plural_name asc}
	    orderby_desc {grade_plural_name desc}
            link_url_eval {[export_vars -base "distribution-edit" { grade_id }]}
            link_html { title "View assignment type distribution" }
	    aggregate ""
	    aggregate_label {@aggregate_label;noquote@}
        }
        weight {
            label "[_ evaluation.lt_Weight_over_100_br__o]"
	    orderby_asc {weight asc}
	    orderby_desc {weight desc}
	    display_template { @grades.weight@% }
	    aggregate "$aggregate"
	    aggregate_label {@total;noquote@}
        }
        comments {
            label "[_ evaluation.description]"
	    orderby_asc {comments asc}
	    orderby_desc {comments desc}
	    aggregate ""
	    aggregate_label {@a_label;noquote@}
	    
        }
	edit {
	    label {}
	    sub_class narrow
	    display_template {<if $simple_p eq 1>[_ evaluation-portlet.edit]</if><else><img src="/resources/acs-subsite/Edit16.gif" width="16" height="16" border="0"></else>
	    } 
	    link_url_eval {[export_vars -base "grades-add-edit" { item_id grade_id }]}
	    link_html { title "[_ evaluation.lt_Edit_assignment_type_]" }
	}
        delete {
            label {}
            sub_class narrow
            display_template {<if $simple_p eq 1>[_ evaluation-portlet.delete]</if><else><img src="/resources/acs-subsite/Delete16.gif" width="16" height="16" border="0"></else>
            } 
            link_url_eval {[export_vars -base "grades-delete" { grade_id return_url }]}
            link_html { title "[_ evaluation.lt_Delete_assignment_typ]" }
        }
    }

set orderby [template::list::orderby_clause -orderby -name grades]

if {[string equal $orderby ""]} {
    set orderby " order by grade_plural_name asc"
}


db_multirow  -extend {} grades  get_class_grades { *SQL* } {
    if { $simple_p } {
	set total [expr $total + $weight]
    }
}

db_1row get_total_weight { *SQL* }

set total_weight [lc_numeric %.2f $total_weight]


if { ($total_weight < 100 && $total_weight > 0) || $total_weight > 100} {
    set notice "<span style=\"font-style: italic; color: red;\">[_ evaluation.lt_The_sum_of_the_weight]</span>"
} else {
    set notice ""
}

ad_return_template
