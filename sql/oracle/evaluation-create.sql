-- jopez@galileo.edu
-- cesarhj@galileo.edu
create table evaluation_grades 
(
        grade_id        integer constraint evaluation_grades_id_pk
                                primary key
                                constraint evaluation_grades_id_fk
                                references cr_revisions(revision_id),
        grade_item_id   integer constraint evaluation_grades_gid_fk
                                references cr_items(item_id),
        grade_name      varchar(100),
        grade_plural_name varchar(100),
        comments        varchar(3000),
        -- percentage of this grade type in the class
        weight          number(5,2) constraint evaluation_grades_w_ck
                                check (weight between 0 and 100)
);

create index ev_grades_giid_index on evaluation_grades(grade_item_id);
create table evaluation_tasks (
        task_id         	integer constraint evaluation_tasks_pk
                                	primary key
                                	constraint evaluation_tasks_fk
                                	references cr_revisions(revision_id),
        task_item_id    	integer constraint evaluation_tasks_tid_fk
                                	references cr_items(item_id),
        task_name       	varchar(200) constraint evaluation_tasks_tn_nn
                                	not null,
        -- we need to know if the task is in groups or not
        number_of_members       integer default 1
					constraint evaluation_tasks_nom_nn
                                        not null,
        due_date                date,
        grade_item_id   	integer constraint evaluation_tasks_gid_fk
                                	references cr_items(item_id),
        -- percentage of the grade of the course
        weight                  number(5,2),
        -- the task will be submitted on line
        online_p    		char(1) constraint      evaluation_tasks_onp_ck
                                	check(online_p in ('t','f')),
        -- will the students be able to submit late their answers?
        late_submit_p   	char(1) constraint evaluations_tasks_lsp_ck
                                        check(late_submit_p in ('t','f')),
        requires_grade_p 	char(1) constraint evaluations_tasks_rgp_ck
                                        check(requires_grade_p in ('t','f'))
);

create index ev_tasks_gid_index on evaluation_tasks(grade_item_id);
create index ev_tasks_tiid_index on evaluation_tasks(task_item_id);

create table evaluation_tasks_sols 
(
        solution_id     integer primary key,
        solution_item_id        integer
                                constraint evaluation_tsols_siid_fk
                                references cr_items(item_id),
        task_item_id    integer constraint evaluation_tsols_tid_fk
                                references cr_items(item_id)
);

-- create indexes
create index ev_tasks_sols_tid_index on evaluation_tasks_sols(task_item_id);

create table evaluation_answers 
(
        answer_id       integer primary key
                                references cr_revisions,
        answer_item_id  integer constraint evaluation_sans_aiid_fk
                                references cr_items(item_id),
        -- person/group to wich the answer belongs
        party_id        integer constraint evaluation_sans_pid_nn
                                not null
                                constraint evaluation_sans_pid_fk
                                references parties(party_id),
        task_item_id    integer constraint evaluation_sans_tid_fk
                                references cr_items(item_id)
);

create index ev_answers_tid_index on evaluation_answers(party_id,task_item_id);
             
create table evaluation_student_evals 
(
        evaluation_id   	integer constraint evaluation_stu_evals_pk
                                        primary key
                                        constraint evaluation_stu_evals_fk
                                        references acs_objects(object_id),
        evaluation_item_id 	integer constraint evaluation_stu_evals_eiid
                                        references cr_items(item_id),
        task_item_id            integer constraint evaluation_stu_evals_tid_nn
                                        not null
                                        constraint evaluation_stu_evals_tid_fk
                                        references cr_items(item_id),
        -- must have student_id or team_id
        party_id                integer constraint evaluation_stu_evals_pid_nn
                                        not null
                                        constraint evaluation_stu_evals_pid_fk
                                        references parties(party_id),
        grade                   number(5,5),
        show_student_p  	char(1) default 't'
                                        constraint evaluation_stu_evals_ssp_ck
                                        check (show_student_p in ('t','f'))
);

create index ev_student_evals_tid_index on evaluation_student_evals(task_item_id);
create index ev_student_evals_pid_index on evaluation_student_evals(party_id);

-- table to store the csv sheet grades associated with the evaluations
create table evaluation_grades_sheets 
(
     grades_sheet_id         integer     primary key,
     grades_sheet_item_id    integer     constraint evaluation_gsheets_giid_fk
                                         references cr_items(item_id),
     task_item_id            integer     constraint evaluation_gsheets_t_id_fk
                                         references cr_items(item_id)
);

-- create indexes
create index ev_grades_sheets_tid_index on evaluation_grades_sheets(task_item_id);

begin
   acs_object_type.create_type(
     supertype            => 'acs_object',
     object_type          => 'evaluation_task_groups',
     pretty_name          => 'Task Group',
     pretty_plural        => 'Tasks Groups',
     table_name           => 'evaluation_task_groups',
     id_column            => 'group_id',
     package_name         => null
   );
end;
/

-- creating group_type and the table where we are going to store the information about evaluation groups for tasks in groups

create table evaluation_task_groups 
(
        group_id                integer constraint ev_task_groups_pk
                                        primary key
                                        constraint ev_task_groups_fk
                                        references groups(group_id),
        task_item_id            integer constraint ev_task_groups_tid_nn
                                        not null
                                        constraint ev_task_groups_tid_fk
                                        references cr_items(item_id)
);

create index ev_task_groups_tid_index on evaluation_task_groups(task_item_id);

insert into group_types (group_type) values ('evaluation_task_groups');

insert into acs_object_type_tables
    (object_type, table_name, id_column)
    values
    ('evaluation_task_groups', 'evaluation_task_groups', 'group_id');

declare
    attr_id acs_attributes.attribute_id%TYPE;
begin
    attr_id := acs_attribute.create_attribute
   (
    object_type     => 'evaluation_task_groups',       
    attribute_name  => 'task_id',                      
    datatype        => 'integer',                      
    pretty_name     => 'Task id',                      
    pretty_plural   => 'Task ids',                     
    table_name      => 'evaluation_task_groups',       
    column_name     => 'task_id',                              
    min_n_values    => 1,                                      
    max_n_values    => 1,                                      
    storage         => 'type_specific'                        
    );
end;
/

-- Definicion del Paquete
create or replace package evaluation
as
 function grade_name 
 (
       grade_id  in evaluation_grades.grade_id%TYPE  
 )return varchar;
 function task_name
 (
       task_id  in evaluation_tasks.task_id%TYPE
 )return varchar;
 function party_name
 (
       p_party_id in evaluation_tasks.task_id%TYPE,    
       p_task_id  in evaluation_tasks.task_id%TYPE
 )return varchar;
 function party_id
 (
       p_user_id in evaluation_tasks.task_id%TYPE,
       p_task_id in evaluation_tasks.task_id%TYPE
 )return parties.party_id%TYPE;
 function class_total_grade
 (                                                                                                            
       p_user_id in acs_objects.context_id%TYPE,
       p_package_id acs_objects.context_id%TYPE
 )return integer;
 function new_evaluation_task_group
 (
       p_task_group_id integer,  
       p_task_group_name varchar,
       p_join_policy varchar,    
       p_creation_date date,  
       p_creation_user integer,   
       p_creation_ip varchar,    
       p_context_id integer,     
       p_task_item_id integer       
 )return integer;
 function delete_evaluation_task_group
 (
       p_task_group_id integer
 )return integer;
end evaluation;
/
show errors

-- Cuerpo del Paquete
create or replace package body evaluation 
as 
 function grade_name 
 ( 
       grade_id in evaluation_grades.grade_id%TYPE
 )return varchar 
 is 
       v_grade_name evaluation_grades.grade_name%TYPE;
 begin 
 select grade_name into v_grade_name 
 from evaluation_grades where grade_id = grade_name.grade_id; 
 return v_grade_name; 
end grade_name; 

function task_name
 (
       task_id in evaluation_tasks.task_id%TYPE
 )return varchar
 is
       v_task_name evaluation_tasks.task_name%TYPE;
 begin
 select task_name into  v_task_name 
 from evaluation_tasks where task_id = task_name.task_id;
 return v_task_name;
end task_name;

 function party_name
 (
       p_party_id in evaluation_tasks.task_id%TYPE,
       p_task_id  in evaluation_tasks.task_id%TYPE
 )return varchar
 is
       v_number_of_members evaluation_tasks.number_of_members%TYPE;    
 begin
        select number_of_members into v_number_of_members
        from evaluation_tasks
        where task_id = party_name.p_task_id;                                                                                                                                  if v_number_of_members = 1 then
                return person.last_name(p_party_id)||', '||person.first_names(p_party_id);
        else
                return acs_group.name(party_name.p_party_id);
        end if;
 end party_name;

 function party_id
 (
       p_user_id in evaluation_tasks.task_id%TYPE,
       p_task_id in evaluation_tasks.task_id%TYPE
 )return parties.party_id%TYPE
 is 
       v_number_of_members evaluation_tasks.number_of_members%TYPE;
       midato evaluation_tasks.task_id%TYPE;
 begin
       select number_of_members into v_number_of_members
       from evaluation_tasks
       where task_id = party_id.p_task_id;
       if v_number_of_members = 1 then
                return party_id.p_user_id;
       else
       select nvl(etg.group_id,0) into midato from evaluation_task_groups etg,
                                                evaluation_tasks et,
                                                acs_rels map
                                                where map.object_id_one = etg.group_id
                                                  and map.object_id_two = p_user_id
                                                  and etg.task_item_id = et.task_item_id
                                                  and et.task_id = p_task_id;
               return midato;                
       end if;
 end party_id;

 function class_total_grade
 (                                                                                                                                                         
       p_user_id in acs_objects.context_id%TYPE,
       p_package_id acs_objects.context_id%TYPE
 )return integer
 is
       v_grade evaluation_student_evals.grade%TYPE;
 begin
       v_grade := 0;
       FOR row in (select nvl(sum(round((ese.grade*et.weight*eg.weight)/10000,2)),0) as grade
        from evaluation_grades eg, evaluation_tasks et, evaluation_student_evals ese, acs_objects ao, cr_items cri1, cr_items cri2, cr_items cri3
        where et.task_item_id = ese.task_item_id and et.grade_item_id = eg.grade_item_id and eg.grade_item_id = ao.object_id  and ao.context_id = class_total_grade.p_package_id and ese.party_id =
        ( select
        CASE
          WHEN et3.number_of_members = 1 THEN class_total_grade.p_user_id
          ELSE
        (select etg2.group_id from evaluation_task_groups etg2,
                                                      evaluation_tasks et2,
                                                      acs_rels map
                                                      where map.object_id_one = etg2.group_id
                                                        and map.object_id_two = class_total_grade.p_user_id
                                                        and etg2.task_item_id = et2.task_item_id
                                                        and et2.task_id = et.task_id)
        END as nom
               from evaluation_tasks et3
              where et3.task_id = et.task_id
        )
        and cri1.live_revision = eg.grade_id
        and cri2.live_revision = et.task_id
        and cri3.live_revision = ese.evaluation_id)      
       LOOP
            v_grade := v_grade + row.grade;
       END LOOP;
       return v_grade;
end class_total_grade;
function new_evaluation_task_group
 (
       p_task_group_id integer,
       p_task_group_name varchar,
       p_join_policy varchar,
       p_creation_date date,
       p_creation_user integer,
       p_creation_ip varchar,
       p_context_id integer,
       p_task_item_id integer
 )return integer
 is
       v_group_id integer;
 begin
       v_group_id := acs_group.new (
            p_task_group_id,
            'evaluation_task_groups',
            p_creation_date,
            p_creation_user,
            p_creation_ip,
            null,
            null,
            p_task_group_name,
            p_join_policy,
            p_context_id
        );                                                                                                                                                           insert into evaluation_task_groups
                (group_id,
                        task_item_id)
        values
                (v_group_id,
                        p_task_item_id);
 return v_group_id;
end new_evaluation_task_group;
 function delete_evaluation_task_group
 (
       p_task_group_id integer
 )return integer
 is
       total integer;
 begin
        total := 0;
        FOR row in (select evaluation_id from evaluation_student_evals where party_id = p_task_group_id)
        LOOP
        content_revision.del(revision_id => row.evaluation_id);
        END LOOP;
                                                                                                                                                             
        FOR row in (select answer_id from evaluation_answers where party_id = p_task_group_id)
        LOOP
        content_revision.del(revision_id => row.answer_id);
        END LOOP;
                                                                                                                                                             
        FOR row in (select rel_id from acs_rels where object_id_one = p_task_group_id)
        LOOP
        acs_rel.del(rel_id => row.rel_id);
        END LOOP;
                                                                                                                                                             
        delete from evaluation_task_groups
        where group_id = p_task_group_id;
                                                                                                                                                             
        delete from groups where group_id = p_task_group_id;
                                                                                                                                                             
        delete from parties where party_id = p_task_group_id;
                                                                                                                                                             
        acs_group.del(p_task_group_id);
    return total;
 end delete_evaluation_task_group;
end evaluation;
/
show errors

create table evaluation_user_profile_rels 
(
    rel_id  integer constraint ev_user_profile_rels_pk
            primary key
);


begin
    acs_rel_type.create_type
    (
      rel_type        => 'evaluation_task_group_rel',
      pretty_name     => 'Evaluation Task Group Member',
      pretty_plural   => 'Evaluation Task Group Members',
      supertype       => 'membership_rel',
      table_name      => 'evaluation_user_profile_rels',
      id_column       => 'rel_id',
      package_name    => 'evaluation',
      object_type_one => 'evaluation_task_groups',
      role_one        => null,
      min_n_rels_one  => 0,
      max_n_rels_one  => null,
      object_type_two => 'user',
      role_two        => null,
      min_n_rels_two  => 0,
      max_n_rels_two  => 1
    );
end;
/

@ evaluation-calendar-create.sql

