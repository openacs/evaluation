# /packages/evaluation/tcl/apm-callback-procs.tcl

ad_library {

	Evaluations Package APM callbacks library
    
    Procedures that deal with installing, instantiating, mounting.

    @creation-date Apr 2004
    @author jopez@galileo.edu
    @cvs-id $Id$
}

namespace eval evaluation::apm_callbacks {}

ad_proc -private evaluation::apm_callbacks::package_instantiate { 
	-package_id:required
} {

	Define Evaluation folders

} {

	set creation_user [ad_verify_and_get_user_id]
	set creation_ip [ad_conn peeraddr]

    db_transaction {
		db_exec_plsql create_evaluation_folders { 			
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
										   'evaluation_student_evals_'||:package_id,
										   'evaluation_student_evals_'||:package_id,
										   'Evaluation student evaluations folder',
										   null,
										   'evaluation_student_evals'
										   );
		}				
		
		set creation_user [ad_verify_and_get_user_id]
		set creation_ip [ad_conn peeraddr]
		
		set exams_item_id [db_nextval acs_object_id_seq]
		set exams_item_name "evaluation_grades_${exams_item_id}"		
		set exams_revision_id [db_nextval acs_object_id_seq]
		set exams_revision_name "evaluation_grades_${exams_revision_id}"
		
		db_exec_plsql exams_item_new { 			
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
		}
		
		db_exec_plsql exams_revision_new { 			
			select evaluation__new_grade (
										  :exams_item_id,		
										  :exams_revision_id,	
										  'Exams', 	
										  -1,		-- class_id temporal
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
		}
		
		db_exec_plsql exams_live_revision { 		
			select content_item__set_live_revision (
													:exams_revision_id			
													);
		}
		
		set projects_item_id [db_nextval acs_object_id_seq]
		set projects_item_name "evaluation_grades_${projects_item_id}"		
		set projects_revision_id [db_nextval acs_object_id_seq]
		set projects_revision_name "evaluation_grades_${projects_revision_id}"
		
		db_exec_plsql projects_item_new { 			
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
		}
		
		db_exec_plsql projects_revision_new { 			
			select evaluation__new_grade (
										  :projects_item_id,		
										  :projects_revision_id,	
										  'Projects', 	
										  -1,		-- class_id temporal
										  40,		
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
		}

		db_exec_plsql projects_live_revision { 		
			select content_item__set_live_revision (
													:projects_revision_id			
													);
		}
		
		set tasks_item_id [db_nextval acs_object_id_seq]
		set tasks_item_name "evaluation_grades_${tasks_item_id}"		
		set tasks_revision_id [db_nextval acs_object_id_seq]
		set tasks_revision_name "evaluation_grades_${tasks_revision_id}"
		
		db_exec_plsql tasks_item_new { 			
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
		}
		
		db_exec_plsql tasks_revision_new { 			
			select evaluation__new_grade (
										  :tasks_item_id,		
										  :tasks_revision_id,	
										  'Tasks', 	
										  -1,		-- class_id temporal
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
		}
		
		db_exec_plsql tasks_live_revision { 
			select content_item__set_live_revision (
													:tasks_revision_id			
													);
		}
    }
}


ad_proc -private evaluation::apm_callbacks::package_uninstantiate { 
	-package_id:required
} {

	Delete Evaluation stuff

} {
	
	set ev_grades_fid [db_string get_f_id "select content_item__get_id('evaluation_grades_'||:package_id,null,'f')"]
	set ev_tasks_fid [db_string get_f_id "select content_item__get_id('evaluation_tasks_'||:package_id,null,'f')"]
	set ev_tasks_sols_fid [db_string get_f_id "select content_item__get_id('evaluation_tasks_sols_'||:package_id,null,'f')"]
	set ev_answers_fid [db_string get_f_id "select content_item__get_id('evaluation_answers_'||:package_id,null,'f')"]
	set ev_student_evals_fid [db_string get_f_id "select content_item__get_id('evaluation_student_evals_'||:package_id,null,'f')"]

    db_transaction {
		db_exec_plsql delte_evaluation_folders { 
			select evaluation__delete_contents (
												:package_id
												);
			
			select evaluation__delete_folder (
											  :ev_grades_fid,
											  'evaluation_grades'
											  );
			
			select evaluation__delete_folder (
											  :ev_tasks_fid,
											  'evaluation_tasks'
											  );
			
			select evaluation__delete_folder (
											  :ev_tasks_sols_fid,
											  'evaluation_tasks_sols'
											  );
			
			select evaluation__delete_folder (
											  :ev_answers_fid,
											  'evaluation_answers'
											  );
			
			select evaluation__delete_folder (
											  :ev_student_evals_fid,
											  'evaluation_student_evals'
											  );
		}
    }
}
