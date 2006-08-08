-- jopez@inv.it.uc3m.es

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

---------------------------------------
-- GRADE FUNCIONS
---------------------------------------

drop function evaluation__task_grade (integer, integer);

drop function evaluation__grade_total_grade (integer, integer);

drop function evaluation__class_total_grade (integer, integer);

drop function evaluation__clone_task(integer,integer);

---------------------------------------
-- OTHER FUNCIONS
---------------------------------------

drop function evaluation__party_name (integer,integer);

drop function evaluation__party_id (integer,integer);

drop function evaluation__delete_contents (integer);


