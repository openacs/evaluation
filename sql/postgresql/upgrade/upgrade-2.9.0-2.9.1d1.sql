--
-- Alter caveman style booleans (type character(1)) to real SQL boolean types.
--

drop view evaluation_tasksx;
drop view evaluation_tasksi cascade;

ALTER TABLE evaluation_tasks
      DROP constraint IF EXISTS evaluation_tasks_onp_ck,
      ALTER COLUMN online_p TYPE boolean
      USING online_p::boolean;

ALTER TABLE evaluation_tasks
      DROP constraint IF EXISTS evaluations_tasks_lsp_ck,
      DROP constraint IF EXISTS evaluations_tasks_rgp_ck,
      ALTER COLUMN late_submit_p TYPE boolean
      USING late_submit_p::boolean;

ALTER TABLE evaluation_tasks
      ALTER COLUMN requires_grade_p TYPE boolean
      USING requires_grade_p::boolean;

ALTER TABLE evaluation_tasks
      DROP constraint IF EXISTS evaluation_tasks_frp_ck,
      ALTER COLUMN forums_related_p TYPE boolean
      USING forums_related_p::boolean;


drop view evaluation_student_evalsx;
drop view evaluation_student_evalsi cascade;

ALTER TABLE evaluation_student_evals
      DROP constraint IF EXISTS evaluation_stu_evals_ssp_ck,
      ALTER COLUMN show_student_p DROP DEFAULT,
      ALTER COLUMN show_student_p TYPE boolean
      USING show_student_p::boolean,
      ALTER COLUMN show_student_p SET DEFAULT false;


select content_type__refresh_view('evaluation_tasks') from dual;
select content_type__refresh_view('evaluation_student_evals') from dual;
