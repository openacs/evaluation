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
            label "Name"
			orderby_asc {task_grade asc}
			orderby_desc {task_grade desc}
        }
        last_modified {
            label "Last Modified"
			orderby_asc {last_modified asc}
			orderby_desc {last_modified desc}
        }
        modifying_user {
            label "Modifying User"
			orderby_asc {modifying_user asc}
			orderby_desc {modifying_user desc}
        }
        comments {
            label "Comments"
			orderby_asc {comments asc}
			orderby_desc {comments desc}
        }
        is_live {
            label "Is live?"
			orderby_asc {comments asc}
			orderby_desc {comments desc}
        }
	}


db_multirow grade_tasks get_task_audit_info { *SQL* } {
}

