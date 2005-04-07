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
	case when content_revision__is_live(ese.evaluation_id) = true then 1
	  else 0 
      	end as is_live
	from evaluation_student_evalsx ese, evaluation_tasks et
	where ese.task_item_id = :task_item_id
      and ese.party_id = :party_id
	and et.task_item_id = ese.task_item_id
	and content_revision__is_live(et.task_id) = true
	$orderby

      </querytext>
</fullquery>

</queryset>
