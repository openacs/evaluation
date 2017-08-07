ad_page_contract {
} {
    grade_id:naturalnum,notnull
    task_id:naturalnum,notnull
    {answer_id:naturalnum ""}
} 

set user_id [ad_conn user_id]
set page_title [_ evaluation.view_answers_]
set context [list $page_title]
set base_url "[ad_conn package_url]"
db_1row get_task_info {}
set return_url "answer-view?grade_id=$grade_id&task_id=$task_id&answer_id=$answer_id"
set elements [list answer_id \
		  [list label "[_ evaluation.answers_]" \
		       link_url_col answer_url \
		       display_template { @answers.title@} \
		       link_html { title "[_ evaluation-portlet.View_my_answer_]" }]]

lappend elements created_date [list label "[_ evaluation.creation_date_]"]


template::list::create \
    -name answers \
    -multirow answers \
    -main_class pbs_list \
    -sub_class narrow \
    -elements $elements 


db_multirow -extend {created_date answer answer_url title} answers answers {} {
    set submitted_date_url ""
    set submitted_date ""
    if { [db_0or1row get_answer_info { *SQL* }] } {
    
	# working with answer stuff (if it has a file/url attached)
	if {$answer_title eq "link"} {
	    # there is a bug in the template::list, if the url does not has a http://, ftp://, the url is not absolute,
	    # so we have to deal with this case
	    array set community_info [site_node::get -url "[dotlrn_community::get_community_url [dotlrn_community::get_community_id]][evaluation::package_key]"]
	    if { ![regexp ([join [split [parameter::get -parameter urlProtocols -package_id $community_info(package_id)] ","] "|"]) "$answer_data"] } {
		set answer_data "http://$answer_data"
	    } 
	    set answer_url "[export_vars -base "$answer_data" { }]"
	    set answer "[_ evaluation-portlet.View_my_answer_]"
	} else {
	    # we assume it's a file
	    set answer_url "[export_vars -base "${base_url}view/$answer_title" { {revision_id $answer_id} }]"
	    set answer "[_ evaluation-portlet.View_my_answer_]"
	}
	
	if { $number_of_members > 1 && [string equal [db_string get_group_id { *SQL* }] "0"] } {
	    set answer ""
	    set answer_url ""
	    set grade "[_ evaluation-portlet.No_group_for_task_]"
	}
    } else {
	
	set answer_url ""
	set answer ""
    }
    set title $answer_title
    set created_date $creation_date
}

if { [db_string compare_due_date { *SQL* } -default 0] } {
    if { ![db_0or1row get_answer_info { *SQL* }] } {
	set submitted_date "[_ evaluation-portlet.submit_answer_]"
	set submitted_date_mode edit
	set submitted_date_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id return_url answer_mode }]"
    } else { 
	set submitted_date "[_ evaluation-portlet.submit_answer_again_]"
	set submitted_date_mode display
			set submitted_date_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id answer_id return_url answer_mode }]"
    }
} elseif {$late_submit_p == "t"} {
    if { ![db_0or1row get_answer_info { *SQL* }] } {
	set submitted_date "[_ evaluation-portlet.lt_submit_answer_style_f]"
	set submitted_date_mode edit
	set submitted_date_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id return_url answer_mode }]"
    } else {
	set submitted_date "[_ evaluation-portlet.lt_submit_answer_style_f_1]"
	set submitted_date_mode display
	set submitted_date_url "[export_vars -base "${base_url}answer-add-edit" { grade_id task_id answer_id return_url answer_mode }]"
    } 
	
    
}

template::head::add_css -href "/resources/evaluation/evaluation.css"
ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
