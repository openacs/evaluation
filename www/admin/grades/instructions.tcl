ad_page_contract {
} {
    grade_id:naturalnum,notnull
}

db_1row grade_info {}
db_1row get_grade_tasks {}
set link_1 "grades"
set link_2 "../tasks/task-add-edit?grade_id=$grade_id&return_url=../grades/distribution-edit?grade_id=$grade_id&return_p=1"
set cat_weight "[_ evaluation.Over_category]"
set total_grade "[_ evaluation.Over_total_grade]"
set equal_value "[_ evaluation.equal_value]"
set options "[_ evaluation.inst_options]"
set instructions "[_ evaluation.inst_step_1]"


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
