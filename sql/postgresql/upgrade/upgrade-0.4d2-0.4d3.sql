alter table evaluation_answers add column comment text; 

drop function evaluation__new_answer (integer, integer, integer, integer, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar);



-- added
select define_function_args('evaluation__new_answer','item_id,revision_id,task_item_id,party_id,object_type,creation_date,creation_user,creation_ip,title;null,publish_date,nls_language;null,mime_type;null,comment');

--
-- procedure evaluation__new_answer/13
--
CREATE OR REPLACE FUNCTION evaluation__new_answer(
   p_item_id integer,
   p_revision_id integer,
   p_task_item_id integer,
   p_party_id integer,
   p_object_type varchar,
   p_creation_date timestamptz,
   p_creation_user integer,
   p_creation_ip varchar,
   p_title varchar,        -- default null
   p_publish_date timestamptz,
   p_nls_language varchar, -- default null
   p_mime_type varchar,    -- default null
   p_comment text

) RETURNS integer AS $$
DECLARE

	v_revision_id		integer;

BEGIN

    v_revision_id := content_revision__new(
        p_title,               	-- title
		'evaluation answer',	 	-- description
		p_publish_date,			-- publish_date
		p_mime_type,			-- mime_type
		p_nls_language,			-- nls_language
		null,					-- data
		p_item_id,				-- item_id
		p_revision_id,			-- revision_id
		p_creation_date,		-- creation_date
		p_creation_user,		-- creation_user
		p_creation_ip,			-- creation_ip
	    null				    -- content length
    );

	insert into evaluation_answers
			(answer_id,
			answer_item_id,
	        task_item_id,
	        party_id,comment)
	values
			(v_revision_id,
			p_item_id, 
	   		p_task_item_id,
    		p_party_id,p_comment);

	return v_revision_id;
END;

$$ LANGUAGE plpgsql;


