-- jopez@galileo.edu
\i evaluation-calendar-drop.sql
create function inline_0 ()
returns integer as'
declare
  del_rec record;
begin
  for del_rec in select item_id from cr_items 
	where content_type in (''evaluation_grades'', ''evaluation_tasks'', ''evaluation_tasks_sols'', ''evaluation_answers'', ''evaluation_student_evals'', ''evaluation_grades_sheets'')
  loop 
    PERFORM content_item__delete(del_rec.item_id);
  end loop;
return 0;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();

create function inline_0 ()
returns integer as'
declare
  del_rec record;
begin
  for del_rec in select item_id from cr_items 
	where content_type in (''evaluation_grades'', ''evaluation_tasks'', ''evaluation_tasks_sols'', ''evaluation_answers'', ''evaluation_student_evals'', ''evaluation_grades_sheets'')
  loop 
    PERFORM content_item__delete(del_rec.item_id);
  end loop;
return 0;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();


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

select acs_object_type__drop_type('evaluation_task_group','f');
select acs_rel_type__drop_type('evaluation_task_group_rel','t');

create function inline_1 ()
returns integer as'
begin
PERFORM acs_object_type__drop_type(''evaluation_grades'',''f'');
PERFORM acs_object_type__drop_type(''evaluation_tasks'',''f'');
PERFORM acs_object_type__drop_type(''evaluation_tasks_sols'',''f'');
PERFORM acs_object_type__drop_type(''evaluation_answers'',''f'');
PERFORM acs_object_type__drop_type(''evaluation_grades_sheets'',''f'');
PERFORM acs_object_type__drop_type(''evaluation_student_evals'',''f'');
PERFORM acs_object_type__drop_type(''evaluation_task_groups'',''f'');

return 0;
end;' language 'plpgsql';
select inline_1 ();
drop function inline_1 ();

drop index evalutaion_tasks_sols_tid_index;
drop view evaluation_tasks_solsi;
drop view evaluation_tasks_solsx;
drop table evaluation_tasks_sols;

drop index evalutaion_grades_sheets_tid_index;
drop view evaluation_grades_sheetsi;
drop view evaluation_grades_sheetsx;
drop table evaluation_grades_sheets;

drop index evaluation_student_evals_tid_index;
drop index evaluation_student_evals_pid_index;
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

---------------------------------------
-- GRADES
---------------------------------------

drop function grade__name(integer);

---------------------------------------
-- TASKS
---------------------------------------

drop function task__name(integer);

drop function evaluation__new_evaluation_task_group(integer,varchar,varchar,timestamptz,integer,varchar,integer,integer);

drop function evaluation__delete_evaluation_task_group(integer);

delete from acs_rels where rel_type = 'evaluation_task_group_rel';

drop table evaluation_user_profile_rels;

select acs_rel_type__drop_type('evaluation_task_group_rel','t');

select acs_object_type__drop_type('evaluation_task_group_rel','f');

---------------------------------------
-- GRADE FUNCIONS
---------------------------------------

drop function evaluation__task_grade (integer, integer);

drop function evaluation__grade_total_grade (integer, integer);

drop function evaluation__class_total_grade (integer, integer);

---------------------------------------
-- OTHER FUNCIONS
---------------------------------------

drop function evaluation__party_name (integer,integer);

drop function evaluation__party_id (integer,integer);

drop function evaluation__delete_contents (integer);

---------------------------------------
-- TEMPLATES
---------------------------------------

drop function evaluation__delete_template ();

drop function evaluation__create_template ();
