# /packages/evaluaiton/www/admin/grades/distribution-edit.tcl

ad_page_contract {
    Bulk edit grade's distribution

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    grade_id:integer,notnull
} 

set user_id [ad_conn user_id]

set page_title "[_ evaluation.lt_Assignment_Types_Dist]"
set context [list [list "grades" "[_ evaluation.Assignment_Types_]"] "[_ evaluation.lt_Assignment_Types_Dist]"]

db_1row grade_info { *SQL* }

set elements [list task_name \
		  [list label "[_ evaluation.Name_]" \
		       orderby_asc {task_name asc} \
		       orderby_desc {task_name desc}] \
		  task_weight \
		  [list label "[_ evaluation.lt_Weight_over_grade_wei]" \
		       display_template { <input size=3 maxlength=6 type=text name=weights.@grades.task_id@ value=@grades.task_weight@>% } \
		       aggregate sum \
		       aggregate_label { Total }
		      ] \
		  requires_grade \
		  [list label "[_ evaluation.Requires_Grade_]" \
		       display_template { [_ evaluation.Yes_] <input @grades.radio_yes_checked@ type=radio name="no_grade.@grades.task_id@" value=t> [_ evaluation.No_] <input @grades.radio_no_checked@ type=radio name="no_grade.@grades.task_id@" value=f> } \
					     ] \
		       ]
	      
template::list::create \
    -name grades \
    -multirow grades \
    -key task_id \
    -filters { grade_id {} } \
    -elements $elements 


set orderby [template::list::orderby_clause -orderby -name grades]

if { [string equal $orderby ""] } {
    set orderby " order by task_name asc"
}

db_multirow -extend { radio_yes_checked radio_no_checked } grades get_grade_tasks { *SQL* } {
    
    set task_weight [lc_numeric %.2f $task_weight]
    if { [string eq $requires_grade_p "t"] } {
	set radio_yes_checked "checked"
	set radio_no_checked ""
    } else {
	set radio_yes_checked ""
	set radio_no_checked "checked"
    }    
} 	





