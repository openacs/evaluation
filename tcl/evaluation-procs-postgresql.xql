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

<fullquery name="evaluation::new_grades_sheet.content_item_new">      
      <querytext>

			select evaluation__new_item (
		    :item_id, --item_id
			:item_name,
			null, --locale
			:creation_user,
			:package_id,
			:creation_ip,
			:title,
			'grades sheet',
			:mime_type, --mime_type
			null, --nls_language
			null, --text
			:storage_type, --storage_type
			'content_item', -- item_subtype
			'evaluation_grades_sheets' -- content_type
			);

      </querytext>
</fullquery>

<fullquery name="evaluation::new_grades_sheet.content_revision_new">      
      <querytext>

	select evaluation__new_grades_sheet (
			:item_id,		
			:revision_id,	
			:task_id,
			'evaluation_grades_sheets',	
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

<fullquery name="evaluation::notification::get_url.get_grade_id">      
      <querytext>

	select grade_id from evaluation_tasks where task_id = :task_id and content_revision__is_live(task_id) = true
	
      </querytext>
</fullquery>

<fullquery name="evaluation::notification::do_notification.select_names">      
      <querytext>

	select eg.grade_name, 
	et.task_name 
	from evaluation_grades eg, 
	evaluation_tasks et 
	where et.task_id = :task_id
	and et.grade_id = eg.grade_id
	
      </querytext>
</fullquery>

<fullquery name="evaluation::notification::do_notification.get_eval_info">      
      <querytext>

	select description as edit_reason, 
	grade as current_grade,
	evaluation__party_name(party_id,task_id) as party_name
	from evaluation_student_evalsi
	where evaluation_id = :evaluation_id
	
      </querytext>
</fullquery>

<fullquery name="evaluation::apm::create_folders.create_evaluation_folders">      
      <querytext>

	    select evaluation__new_folder (
					   'evaluation_grades_'||:package_id,
					   'evaluation_grades_'||:package_id,
					   'Evaluation grades folder',
					   null,
					   'evaluation_grades'
					   );
	    
	    select evaluation__new_folder (
					   'evaluation_tasks_'||:package_id,
					   'evaluation_tasks_'||:package_id,
					   'Evaluation tasks folder',
					   null,
					   'evaluation_tasks'
					   );
	    
	    select evaluation__new_folder (
					   'evaluation_tasks_sols_'||:package_id,
					   'evaluation_tasks_sols_'||:package_id,
					   'Evaluation tasks solutions folder',
					   null,
					   'evaluation_tasks_sols'
					   );
	    
	    select evaluation__new_folder (
					   'evaluation_answers_'||:package_id,
					   'evaluation_answers_'||:package_id,
					   'Evaluation answers folder',
					   null,
					   'evaluation_answers'
					   );
	    
	    select evaluation__new_folder (
					   'evaluation_grades_sheets_'||:package_id,
					   'evaluation_grades_sheets_'||:package_id,
					   'Grades sheets folder',
					   null,
					   'evaluation_grades_sheets'
					   );
	    
	    select evaluation__new_folder (
					   'evaluation_student_evals_'||:package_id,
					   'evaluation_student_evals_'||:package_id,
					   'Evaluation student evaluations folder',
					   null,
					   'evaluation_student_evals'
					   );

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::create_folders.exams_item_new">      
      <querytext>

	    select evaluation__new_item (
					 :exams_item_id, --item_id
					 :exams_item_name,
					 null,
					 :creation_user,
					 :package_id,
					 :creation_ip,
					 'Exams',
					 'Exams for students',
					 'text/plain',
					 null,
					 null,
					 'text',
					 'content_item', -- item_subtype
					 'evaluation_grades' -- content_type
					 );

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::create_folders.exams_revision_new">      
      <querytext>

	    select evaluation__new_grade (
					  :exams_item_id,		
					  :exams_revision_id,	
					  'Exams', 	
					  40,		
					  'evaluation_grades',	
					  now(), --creation date	
					  :creation_user, 
					  :creation_ip,	
					  :exams_revision_name,			
					  'Exams for students',	
					  now(),  --publish date
					  null, --nls_language
					  'text/plain' --mime_type
					  );

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::create_folders.exams_live_revision">      
      <querytext>

	    select content_item__set_live_revision (
						    :exams_revision_id			
						    );

      </querytext>
</fullquery>
<fullquery name="evaluation::apm::create_folders.projects_item_new">      
      <querytext>

	    select evaluation__new_item (
					 :projects_item_id, --item_id
					 :projects_item_name,
					 null,
					 :creation_user,
					 :package_id,
					 :creation_ip,
					 'Projects',
					 'Projects for students',
					 'text/plain',
					 null,
					 null,
					 'text',
					 'content_item', -- item_subtype
					 'evaluation_grades' -- content_type
					 );

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::create_folders.projects_revision_new">      
      <querytext>

	    select evaluation__new_grade (
					  :projects_item_id,		
					  :projects_revision_id,	
					  'Projects', 	
					  20,		
					  'evaluation_grades',	
					  now(), --creation date	
					  :creation_user, 
					  :creation_ip,	
					  :projects_revision_name,			
					  'Projects for students',	
					  now(),  --publish date
					  null, --nls_language
					  'text/plain' --mime_type
					  );

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::create_folders.projects_live_revision">      
      <querytext>

	    select content_item__set_live_revision (
						    :projects_revision_id			
						    );

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::create_folders.tasks_item_new">      
      <querytext>

	    select evaluation__new_item (
					 :tasks_item_id, --item_id
					 :tasks_item_name,
					 null,
					 :creation_user,
					 :package_id,
					 :creation_ip,
					 'Tasks',
					 'Tasks for students',
					 'text/plain',
					 null,
					 null,
					 'text',
					 'content_item', -- item_subtype
					 'evaluation_grades' -- content_type
					 );

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::create_folders.tasks_revision_new">      
      <querytext>

	    select evaluation__new_grade (
					  :tasks_item_id,		
					  :tasks_revision_id,	
					  'Tasks', 	
					  40,		
					  'evaluation_grades',	
					  now(), --creation date	
					  :creation_user, 
					  :creation_ip,	
					  :tasks_revision_name,			
					  'Tasks for students',	
					  now(),  --publish date
					  null, --nls_language
					  'text/plain' --mime_type
					  );

      </querytext>
</fullquery>
<fullquery name="evaluation::apm::create_folders.tasks_live_revision">      
      <querytext>

	    select content_item__set_live_revision (
						    :tasks_revision_id			
						    );

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::delete_contents.delte_evaluation_contents">      
      <querytext>

	select evaluation__delete_contents (
					:package_id
					);

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::delete_contents.delte_grades_sheets_folder">      
      <querytext>

	    select evaluation__delete_folder (
					      :ev_grades_sheets_fid,
					      'evaluation_grades_sheets'
					      );

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::delete_contents.delte_grades_folder">      
      <querytext>

	    select evaluation__delete_folder (
					      :ev_grades_fid,
					      'evaluation_grades'
					      );

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::delete_contents.delte_task_folder">      
      <querytext>

	    select evaluation__delete_folder (
					      :ev_tasks_fid,
					      'evaluation_tasks'
					      );

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::delete_contents.delte_task_sols_folder">      
      <querytext>

	    select evaluation__delete_folder (
					      :ev_tasks_sols_fid,
					      'evaluation_tasks_sols'
					      );

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::delete_contents.delte_answers_folder">      
      <querytext>

	    select evaluation__delete_folder (
					      :ev_answers_fid,
					      'evaluation_answers'
					      );

      </querytext>
</fullquery>

<fullquery name="evaluation::apm::delete_contents.delte_evals_folder">      
      <querytext>

	    select evaluation__delete_folder (
					      :ev_student_evals_fid,
					      'evaluation_student_evals'
					      );

      </querytext>
</fullquery>
 
</queryset>
