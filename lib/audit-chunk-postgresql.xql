<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_task_audit_info">      
      <querytext>

	select to_char(ese.last_modified, 'MM-DD-YYYY HH24:MI:SS') as last_modified,
	ese.modifying_user,
	ese.modifying_ip,
	ese.description as comments,
	ese.grade as task_grade,
	content_revision__is_live(evaluation_id) as is_live
	from evaluation_student_evalsx ese
	where ese.task_id = :task_id
      and ese.party_id = :party_id
	order by evaluation__party_name(party_id,task_id), ese.evaluation_id desc

      </querytext>
</fullquery>

</queryset>
