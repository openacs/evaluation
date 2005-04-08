<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_task_audit_info">      
      <querytext>

	select to_char(ese.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified_ansi,
	nvl(person.name(ese.modifying_user),person.name(ese.creation_user)) as modifying_user,
	ese.modifying_ip,
	ese.description as comments,
	ese.grade as task_grade,
	case when content_revision.is_live(ese.evaluation_id) = 't' then 1
	  else 0 
      	end as is_live
	from evaluation_student_evalsx ese, evaluation_tasks et
	where ese.task_item_id = :task_item_id
      and ese.party_id = :party_id
	and et.task_item_id = ese.task_item_id
	and content_revision.is_live(et.task_id) = 't'
	$orderby

      </querytext>
</fullquery>

</queryset>
