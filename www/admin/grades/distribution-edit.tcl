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

set page_title "Assignment Types Distribution"
set context [list [list "grades" "Assignment Types"] "Assignment Types Distribution"]

db_1row grade_info { *SQL* }

set elements [list task_name \
				  [list label "Name" \
					   orderby_asc {task_name asc} \
					   orderby_desc {task_name desc}] \
				  task_weight \
				  [list label "Weight" \
					   display_template { <input size=3 maxlength=6 type=text name=weights.@grades.task_id@ value=@grades.task_weight@> } \
					  ] \
				  requires_grade \
				  [list label "Requires Grade?" \
					   display_template { [if { [string eq @grades.requires_grade_p@ "t"] } { return "Yes <input checked type=radio name=\"no_grade.@grades.task_id@\" value=t> No <input type=radio name=\"no_grade.@grades.task_id@\" value=f>" } else { return "Yes <input type=radio name=\"no_grade.@grades.task_id@\" value=t> No <input checked type=radio name=\"no_grade.@grades.task_id@\" value=f>" }] } \
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

db_multirow grades get_grade_tasks { *SQL* } {
} 	





