alter table evaluation_tasks add column estimated_time decimal; 
 
comment on column evaluation_tasks.estimated_time is ' 
       Estimated time to complete the assignment 
'; 
 
create or replace function evaluation__new_task (integer, integer, varchar, integer, integer, varchar, numeric, timestamptz, char, char, char, decimal, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar) 
returns integer as ' 
declare   
        p_item_id                       alias for $1; 
        p_revision_id           alias for $2; 
        p_task_name             alias for $3; 
        p_number_of_members alias for $4; 
        p_grade_item_id         alias for $5; 
        p_description           alias for $6; 
        p_weight                        alias for $7; 
        p_due_date              alias for $8; 
        p_late_submit_p         alias for $9; 
        p_online_p              alias for $10; 
        p_requires_grade_p  alias for $11; 
        estimated_time          alias for $12; 
        p_object_type           alias for $13; 
        p_creation_date         alias for $14; 
        p_creation_user         alias for $15; 
        p_creation_ip           alias for $16; 
        p_title                         alias for $17; -- default null 
        p_publish_date          alias for $18; 
        p_nls_language          alias for $19; -- default null 
        p_mime_type             alias for $20; -- default null 
 
        v_revision_id           integer; 
 
begin 
 
    v_revision_id := content_revision__new( 
        p_title,                -- title 
                p_description,                  -- description 
                p_publish_date,                 -- publish_date 
                p_mime_type,                    -- mime_type 
                p_nls_language,                 -- nls_language 
                null,                                   -- data 
                p_item_id,                              -- item_id 
                p_revision_id,                  -- revision_id 
                p_creation_date,                -- creation_date 
                p_creation_user,                -- creation_user 
                p_creation_ip,                  -- creation_ip 
            null                                    -- content length 
    ); 
 
        insert into evaluation_tasks  
                        (task_id, 
                        task_item_id, 
                task_name, 
                        number_of_members,  
                        due_date,        
                        grade_item_id,  
                        weight,          
                        online_p,  
                        late_submit_p, 
                    requires_grade_p) 
        values 
                        (v_revision_id, 
                        p_item_id,  
                        p_task_name, 
                        p_number_of_members,  
                        p_due_date,      
                        p_grade_item_id,  
                        p_weight,        
                        p_online_p,  
                        p_late_submit_p, 
                        p_requires_grade_p); 
 
        return v_revision_id; 
end; 
' language 'plpgsql'; 
 
