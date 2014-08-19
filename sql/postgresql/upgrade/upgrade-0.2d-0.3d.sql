alter table evaluation_tasks add column estimated_time decimal; 
 
comment on column evaluation_tasks.estimated_time is ' 
       Estimated time to complete the assignment 
'; 
 


-- added
select define_function_args('evaluation__new_task','item_id,revision_id,task_name,number_of_members,grade_item_id,description,weight,due_date,late_submit_p,online_p,requires_grade_p,estimated_time,object_type,creation_date,creation_user,creation_ip,title;null,publish_date,nls_language;null,mime_type;null');

--
-- procedure evaluation__new_task/20
--
CREATE OR REPLACE FUNCTION evaluation__new_task(
   p_item_id integer,
   p_revision_id integer,
   p_task_name varchar,
   p_number_of_members integer,
   p_grade_item_id integer,
   p_description varchar,
   p_weight numeric,
   p_due_date timestamptz,
   p_late_submit_p char,
   p_online_p char,
   p_requires_grade_p char,
   estimated_time decimal,
   p_object_type varchar,
   p_creation_date timestamptz,
   p_creation_user integer,
   p_creation_ip varchar,
   p_title varchar,        -- default null
   p_publish_date timestamptz,
   p_nls_language varchar, -- default null
   p_mime_type varchar     -- default null

) RETURNS integer AS $$
DECLARE   
 
        v_revision_id           integer; 
 
BEGIN 
 
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
END; 

$$ LANGUAGE plpgsql; 
 
