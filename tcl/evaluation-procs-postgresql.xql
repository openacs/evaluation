<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="evaluation::new_grade.content_item_new">      
      <querytext>

			select evaluation__new_item (
		    :item_id, --item_id
			:item_name,
			null,
			:creation_user,
			:package_id,
			:creation_ip,
			:name,
			:description,
			'text/plain',
			null,
			null,
			'text',
			'content_item', -- item_subtype
			'evaluation_grades' -- content_type
			);

      </querytext>
</fullquery>

<fullquery name="evaluation::new_grade.content_revision_new">      
      <querytext>

			select evaluation__new_grade (
			:item_id,		
			:revision_id,	
			:name, 	
			-1,		-- class_id temporal
			:weight,		
			'evaluation_grades',	
			now(), --creation date	
			:creation_user, 
			:creation_ip,	
			:revision_name,			
			:description,	
			now(),  --publish date
		    null, --nls_language
			'text/plain' --mime_type
			);
	
      </querytext>
</fullquery>

<fullquery name="evaluation::set_live.content_set_live_revision">      
      <querytext>

		select content_item__set_live_revision (
		:revision_id			
		);
	
      </querytext>
</fullquery>

<fullquery name="evaluation::new_task.content_item_new">      
      <querytext>

			select evaluation__new_item (
		    :item_id, --item_id
			:item_name,
			null, --locale
			:creation_user,
			:package_id,
			:creation_ip,
			:name,
			:description,
			:mime_type, --mime_type
			null, --nls_language
			null, --text
			:storage_type, --storage_type
			'content_item', -- item_subtype
			'evaluation_tasks' -- content_type
			);

      </querytext>
</fullquery>

<fullquery name="evaluation::new_task.content_revision_new">      
      <querytext>

	select evaluation__new_task (
			:item_id,		
			:revision_id,	
			:name,
			:number_of_members,
			:grade_id,		-- class_id temporal
			:description,  	
			:weight,	
			:due_date,
			:late_submit_p,
			:online_p,
			:requires_grade_p,
			'evaluation_tasks',	
			now(), --creation date	
			:creation_user, 
			:creation_ip,	
			:item_name,			
			now(),  --publish date
			null,  -- nls_language
			:mime_type --mime_type
			);

      </querytext>
</fullquery>

<fullquery name="evaluation::new_task.update_item_name">      
      <querytext>

		update cr_items 
		set name = :item_name,
		storage_type = :storage_type
		where item_id = :item_id

      </querytext>
</fullquery>

<fullquery name="evaluation::new_solution.content_item_new">      
      <querytext>

			select evaluation__new_item (
		    :item_id, --item_id
			:item_name,
			null, --locale
			:creation_user,
			:package_id,
			:creation_ip,
			:title,
			'task solution',
			:mime_type, --mime_type
			null, --nls_language
			null, --text
			:storage_type, --storage_type
			'content_item', -- item_subtype
			'evaluation_tasks_sols' -- content_type
			);

      </querytext>
</fullquery>

<fullquery name="evaluation::new_solution.content_revision_new">      
      <querytext>

	select evaluation__new_task_sol (
			:item_id,		
			:revision_id,	
			:task_id,
			'evaluation_tasks_sols',	
			now(), --creation date	
			:creation_user, 
			:creation_ip,	
			:item_name,			
			now(),  --publish date
			null,  -- nls_language
			:mime_type --mime_type
			);

      </querytext>
</fullquery>

<fullquery name="evaluation::new_solution.update_item_name">      
      <querytext>

		update cr_items 
		set name = :item_name,
		storage_type = :storage_type
		where item_id = :item_id

      </querytext>
</fullquery>

<fullquery name="evaluation::new_answer.content_item_new">      
      <querytext>

			select evaluation__new_item (
		    :item_id, --item_id
			:item_name,
			null, --locale
			:creation_user,
			:package_id,
			:creation_ip,
			:title,
			'evaluation answer',
			:mime_type, --mime_type
			null, --nls_language
			null, --text
			:storage_type, --storage_type
			'content_item', -- item_subtype
			'evaluation_answers' -- content_type
			);

      </querytext>
</fullquery>

<fullquery name="evaluation::new_answer.content_revision_new">      
      <querytext>

	select evaluation__new_answer (
			:item_id,		
			:revision_id,	
			:task_id,
		    :party_id,
			'evaluation_answers',	
			now(), --creation date	
			:creation_user, 
			:creation_ip,	
			:item_name,			
			now(),  --publish date
			null,  -- nls_language
			:mime_type --mime_type
			);

      </querytext>
</fullquery>

<fullquery name="evaluation::new_answer.update_item_name">      
      <querytext>

		update cr_items 
		set name = :item_name,
		storage_type = :storage_type
		where item_id = :item_id

      </querytext>
</fullquery>

<fullquery name="evaluation::new_evaluation.content_item_new">      
      <querytext>

			select evaluation__new_item (
		    :item_id, --item_id
			:item_name,
			null, --locale
			:creation_user,
			:package_id,
			:creation_ip,
			:title,
			'student evaluation',
			:mime_type, --mime_type
			null, --nls_language
			null, --text
			:storage_type, --storage_type
			'content_item', -- item_subtype
			'evaluation_student_evals' -- content_type
			) where not exists (select 1 from cr_items where item_id = :item_id);

      </querytext>
</fullquery>

<fullquery name="evaluation::new_evaluation.content_revision_new">      
      <querytext>

		select evaluation__new_student_eval (
			:item_id,		
			:revision_id,	
			:task_id,
		    :party_id,
			:grade,
			:show_student_p,
			:description,
			'evaluation_student_evals',	
			now(), --creation date	
			:creation_user, 
			:creation_ip,	
			:item_name,		    --title
			now(),  --publish date
			null,  -- nls_language
			:mime_type --mime_type
			);

      </querytext>
</fullquery>

<fullquery name="evaluation::new_evaluation_group.evaluation_group_new">      
      <querytext>

		select evaluation__new_evaluation_task_group (
													  :group_id,
													  :group_name,
													  'closed',
													  now(),
													  :creation_user,
													  :creation_ip,
													  :context,
													  :task_id
													  );

      </querytext>
</fullquery>

<fullquery name="evaluation::evaluation_group_name.evaluation_group_name">      
      <querytext>

		select acs_group__name(:group_id) as group_name

      </querytext>
</fullquery>
 
</queryset>
