-- jopez@galileo.edu
-- cesarhj@galileo.edu

@evaluation-calendar-drop.sql

--create function inline_0 ()
--returns integer as'
--declare
--  del_rec record;
--begin
--  for del_rec in select item_id from cr_items 
--	where content_type in (''evaluation_grades'', ''evaluation_tasks'', ''evaluation_tasks_sols'', ''evaluation_answers'', ''evaluation_student_evals'', ''evaluation_grades_sheets'')
--  loop 
--    PERFORM content_item__delete(del_rec.item_id);
--  end loop;
--return 0;
--end;' language 'plpgsql';
--select inline_0 ();
--drop function inline_0 ();

--create function inline_0 ()
--returns integer as'
--declare
--  del_rec record;
--begin
--  for del_rec in select item_id from cr_items 
--	where content_type in (''evaluation_grades'', ''evaluation_tasks'', ''evaluation_tasks_sols'', ''evaluation_answers'', ''evaluation_student_evals'', ''evaluation_grades_sheets'')
--  loop 
--    PERFORM content_item__delete(del_rec.item_id);
--  end loop;
--return 0;
--end;' language 'plpgsql';
--select inline_0 ();
--drop function inline_0 ();
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

begin
acs_object_type.drop_type('evaluation_task_group');
end;
/
show errors

begin
acs_rel_type.drop_type('evaluation_task_group_rel');
end;
/
show errors

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
show errors                                                                                                                        

drop index ev_tasks_sols_tid_index;
drop view evaluation_tasks_solsi;
drop view evaluation_tasks_solsx;
drop table evaluation_tasks_sols;

drop index ev_grades_sheets_tid_index;
drop view evaluation_grades_sheetsi;
drop view evaluation_grades_sheetsx;
drop table evaluation_grades_sheets;

drop index ev_student_evals_tid_index;
drop index ev_student_evals_pid_index;
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

-- Usa Funciones CR
--drop function evaluation__new_item (integer,varchar,varchar,integer,integer,timestamptz,varchar,varchar,text,varchar,varchar,text,varchar,varchar,varchar);

---------------------------------------
-- GRADES
---------------------------------------

-- Usa Funciones CR
--drop function evaluation__new_grade (integer, integer, varchar, varchar, numeric, varchar, timestamptz, integer, varchar, varchar, varchar, timestamptz, varchar, varchar);

-- Usa Funciones CR
--drop function evaluation__delete_grade (integer);


-- Originalmente drop function grade__name(integer);
drop package body evaluation;
drop package evaluation;


---------------------------------------
-- TASKS
---------------------------------------

-- Usa Funciones CR
--drop function evaluation__new_task (integer, integer, varchar, integer, integer, varchar, numeric, timestamptz, char, char, char, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar);

-- Usa Funciones CR
--drop function evaluation__delete_task (integer);

-- Ya fue elimina al eliminar el paquete evaluation;
--drop function task__name(integer);

---------------------------------------
-- TASKS SOLUTIONS
---------------------------------------

-- Usa Funciones CR
--drop function evaluation__new_task_sol (integer, integer, integer, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar);

-- Usa Funciones CR
--drop function evaluation__delete_task_sol (integer);

---------------------------------------
-- STUDENT ANSWERS
---------------------------------------

-- Usa Funciones CR
--drop function evaluation__new_answer (integer, integer, integer, integer, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar);

-- Usa Funciones CR
--drop function evaluation__delete_answer (integer);

---------------------------------------
-- GRADES SHEETS
---------------------------------------

-- Usa Funciones CR
--drop function evaluation__new_grades_sheet (integer, integer, integer, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar);

-- Usa Funciones CR
--drop function evaluation__delete_grades_sheet (integer);

---------------------------------------
-- STUDENT EVALUATIONS
---------------------------------------

-- Usa Funciones CR
--drop function evaluation__new_student_eval (integer, integer, integer, integer, numeric, char, text, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar);

-- Usa Funciones CR
--drop function evaluation__delete_student_eval (integer);

---------------------------------------
-- EVALUATION TASK GROUPS
---------------------------------------

-- Usa Funciones CR pero hay que revisar
--drop function evaluation__new_evaluation_task_group(integer,varchar,varchar,timestamptz,integer,varchar,integer,integer);

-- Usa Funciones CR
--drop function evaluation__delete_evaluation_task_group(integer);

begin
delete from acs_rels where rel_type = 'evaluation_task_group_rel';
end;
/
show error
drop table evaluation_user_profile_rels;
begin
acs_rel_type.drop_type('evaluation_task_group_rel');
acs_object_type.drop_type('evaluation_task_group_rel');
end;
/
show error

---------------------------------------
-- GRADE FUNCIONS
---------------------------------------

-- Usa Funciones CR Hace un Calculo Matematico
--drop function evaluation__task_grade (integer, integer);

-- Usa Funciones CR
--drop function evaluation__grade_total_grade (integer, integer);

-- Usa Funciones CR
--drop function evaluation__class_total_grade (integer, integer);

---------------------------------------
-- OTHER FUNCIONS
---------------------------------------

--Fue eliminado con el paquete evaluation
--drop function evaluation__party_name (integer,integer);

-- Fue eliminado con el paqute evaluation
--drop function evaluation__party_id (integer,integer);

-- Usa Funciones CR
--drop function evaluation__new_folder (varchar,varchar,text,integer,varchar);

-- Usa Funciones CR pero hay que revisar.
--drop function evaluation__delete_contents (integer);

-- Usa Funciones CR
--drop function evaluation__delete_folder (integer,varchar);

-- Usa Funciones CR
--drop function evaluation__delete_all_folders_and_contents ();


