<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_task_audit_info">      
      <querytext>

	select to_char(ese.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified_ansi,
	coalesce(person__name(ese.modifying_user),person__name(ese.creation_user)) as modifying_user,
	ese.modifying_ip,
	ese.description as comments,
	ese.grade as task_grade,
	case when content_revision__is_live(evaluation_id) = true then 1
	  else 0 
      	end as is_live
	from evaluation_student_evalsx ese
	where ese.task_id = :task_id
      and ese.party_id = :party_id
	order by evaluation__party_name(party_id,task_id), ese.evaluation_id desc

      </querytext>
</fullquery>

</queryset>
