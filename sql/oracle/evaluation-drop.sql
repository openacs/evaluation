-- jopez@galileo.edu
-- cesarhj@galileo.edu

@ evaluation-calendar-drop.sql

delete from acs_objects where object_type = 'evaluation_grades';
delete from acs_objects where object_type = 'evaluation_tasks';
delete from acs_objects where object_type = 'evaluation_tasks_sols';
delete from acs_objects where object_type = 'evaluation_answers';
delete from acs_objects where object_type = 'evaluation_grades_sheets';
delete from acs_objects where object_type = 'evaluation_student_evals';
delete from acs_objects where object_type = 'evaluation_task_groups';
delete from acs_objects where object_type = 'evaluation_task_group_rel';
delete from acs_attributes where object_type = 'evaluation_task_groups';
delete from acs_object_type_tables where object_type = 'evaluation_task_groups';
delete from group_types where group_type = 'evaluation_task_groups';

drop index eva_tasks_sols_tid_index;
drop view evaluation_tasks_solsi;
drop view evaluation_tasks_solsx;
drop table evaluation_tasks_sols;

drop index eva_grades_sheets_tid_index;
drop view evaluation_grades_sheetsi;
drop view evaluation_grades_sheetsx;
drop table evaluation_grades_sheets;

drop index eva_student_evals_tid_index;
drop index eva_student_evals_pid_index;
drop view evaluation_student_evalsi;
drop view evaluation_student_evalsx;
drop table evaluation_student_evals;

drop view evaluation_answersi;
drop view evaluation_answersx;
drop table evaluation_answers;

drop table evaluation_task_groups;

drop view evaluation_tasksi;
drop view evaluation_tasksx;
drop table evaluation_tasks;

drop view evaluation_gradesi;
drop view evaluation_gradesx;
drop table evaluation_grades;

begin
delete from acs_rels where rel_type = 'evaluation_task_group_rel';
end;
/
show errors;

drop table evaluation_user_profile_rels;

begin
acs_rel_type.drop_type('evaluation_task_group_rel');
acs_object_type.drop_type('evaluation_task_group_rel');
end;
/
show errors;

begin
acs_object_type.drop_type('evaluation_grades');
acs_object_type.drop_type('evaluation_tasks');
acs_object_type.drop_type('evaluation_tasks_sols');
acs_object_type.drop_type('evaluation_answers');
acs_object_type.drop_type('evaluation_grades_sheets');
acs_object_type.drop_type('evaluation_student_evals');
acs_object_type.drop_type('evaluation_task_groups');
end;
/
show errors;

@ evaluation-package-drop.sql

