# /packages/evaluation/www/task-view.tcl

ad_page_contract {
    Page for viewing tasks.

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$
} {
    grade_id:integer,notnull
    task_id:integer,notnull,optional
    item_id:integer,notnull,optional
    {return_url "/"}
}

set package_id [ad_conn package_id]
set page_title "View Task"

db_1row get_grade_info { *SQL* }

set context [list $page_title]

db_1row get_task_info { *SQL* }

if { [string eq $online_p "1"] || [string eq $online_p "t"] } {
	set online_p "Yes"
} else {
	set online_p "No"
}

if { [string eq $late_submit_p "1"] || [string eq $late_submit_p "t"]} {
	set late_submit_p "Yes"
} else {
	set late_submit_p "No"
}

#set description [template::util::richtext::get_property contents $description]
# working with task stuff (if it has a file/url attached)
if { [empty_string_p $task_data] } {
	set task_url "No file/url associated with this task"
} elseif { [regexp "http://" $task_data] } {
	set task_url "<a href=\"$task_data\">$task_data</a>"
} else {
	# we assume it's a file
	set task_url "<a href=\"../view/$task_title\">$task_title</a>"
}

# working with task soluiton stuff (if it has a file/url attached)
if { [empty_string_p $solution_data] } {
	set solution_url "No file/url associated with this task solution"
} elseif { [regexp "http://" $solution_data] } {
	set solution_url "<a href=\"$solution_data\">$solution_data</a>"
} else {
	# we assume it's a file
	set solution_url "<a href=\"../view/$solution_title\">$solution_title</a>"
}

ad_return_template
