<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_evaluation_info">      
      <querytext>

    select ese.grade,
    ese.party_id,
    et.weight as task_weight,
    et.task_id,
    et.task_item_id,
    to_char(et.due_date, 'YYYY-MM-DD HH24:MI:SS') as due_date_ansi,
    et.due_date,
    et.task_name,
    eg.grade_name,
    eg.grade_plural_name,
    eg.weight as grade_weight,
    (et.weight*eg.weight*ese.grade/10000) as net_grade,
    et.number_of_members,
    nvl(person.name(ese.modifying_user),person.name(creation_user)) as grader,
    to_char(ese.last_modified, 'YYYY-MM-DD HH24:MI:SS') as evaluation_date_ansi,
    ese.description as comments
    from evaluation_student_evalsi ese,
    evaluation_tasks et,
    evaluation_grades eg,
    cr_items cri1, cr_items cri2
    where ese.evaluation_id = :evaluation_id
    and ese.task_item_id = et.task_item_id
    and et.grade_item_id = eg.grade_item_id
    and cri1.live_revision = et.task_id
    and cri2.live_revision = eg.grade_id

      </querytext>
</fullquery>

<fullquery name="get_answer_info">      
      <querytext>

    select ea.data as answer_data,
    ea.title as answer_title,
    ea.revision_id as answer_revision_id,
    to_char(ea.creation_date, 'YYYY-MM-DD HH24:MI:SS') as submission_date_ansi,
    ea.last_modified as submission_date,
    nvl(person.name(modifying_user),person.name(creation_user)) as answer_owner
    from evaluation_answersi ea, cr_items cri, evaluation_tasks et, cr_items cri1
    where ea.party_id = evaluation.party_id(ea.party_id,et.task_id)
    and ea.task_item_id = :task_item_id
	and et.task_item_id = ea.task_item_id
    and cri.live_revision = ea.answer_id
	and cri1.live_revision = et.task_id

      </querytext>
</fullquery>

<fullquery name="get_group_info">      
      <querytext>

	select acs_group.name(:party_id) as group_name from dual

      </querytext>
</fullquery>

<fullquery name="group_members">      
      <querytext>

	select person.name(map.object_id_two) as member_name
	from acs_rels map 
	where map.object_id_one = :party_id
    
      </querytext>
</fullquery>

</queryset>
