ad_page_contract {

	Audit chunk for displaying audit info

}

set user_id [ad_conn user_id]

template::list::create \
    -name grade_tasks \
    -multirow grade_tasks \
    -key task_name \
    -pass_properties { return_url } \
    -elements {
        task_grade {
            label "[_ evaluation.Name_]"
	    orderby_asc {task_grade asc}
	    orderby_desc {task_grade desc}
        }
        last_modified {
	    display_col last_modified_pretty
            label "[_ evaluation.Last_Modified_]"
	    
	    orderby_asc {last_modified asc}
	    orderby_desc {last_modified desc}
        }
        modifying_user {
            label "[_ evaluation.Modifying_User_]"
	    orderby_asc {modifying_user asc}
	    orderby_desc {modifying_user desc}
        }
        comments {
            label "[_ evaluation.Comments_]"
	    orderby_asc {comments asc}
	    orderby_desc {comments desc}
        }
        is_live {
            label "[_ evaluation.Is_live_]"
	    orderby_asc {comments asc}
	    orderby_desc {comments desc}
        }
    }


db_multirow -extend { last_modified_pretty } grade_tasks get_task_audit_info { *SQL* } {
    set last_modified_pretty [lc_time_fmt $last_modified_ansi "%q"]
}

