alter table evaluation_answers add column comment text; 

drop function evaluation__new_answer (integer, integer, integer, integer, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar);

create function evaluation__new_answer (integer, integer, integer, integer, varchar, timestamptz, integer, varchar, varchar, timestamptz, varchar, varchar,text)
returns integer as '
declare
	p_item_id			alias for $1;
	p_revision_id		alias for $2;
	p_task_item_id		alias for $3;
    p_party_id  	   	alias for $4;	
	p_object_type		alias for $5;
	p_creation_date		alias for $6;
	p_creation_user 	alias for $7;
	p_creation_ip		alias for $8;
	p_title				alias for $9; -- default null
	p_publish_date		alias for $10;
	p_nls_language   	alias for $11; -- default null
	p_mime_type   		alias for $12; -- default null
	p_comment   		alias for $13; 

	v_revision_id		integer;

begin

    v_revision_id := content_revision__new(
        p_title,               	-- title
		''evaluation answer'',	 	-- description
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
end;
' language 'plpgsql';


