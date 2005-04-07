<?xml version="1.0"?>

<queryset>

<fullquery name="grade_info">      
      <querytext>

    select eg.weight as grade_weight,
    eg.grade_plural_name
    from evaluation_grades eg
    where eg.grade_id = :grade_id

      </querytext>
</fullquery>

<fullquery name="grade_names">      
      <querytext>

		select grade_name, grade_plural_name from evaluation_grades where grade_id = :grade_id
	
      </querytext>
</fullquery>

<fullquery name="get_student_grades">      
      <querytext>

    select et.task_name, 
    et.task_item_id,
    eg.weight as g_weight,
    round(eg.weight,2) as grade_weight,
    et.task_id,
    et.weight as t_weight,
    round((et.weight*eg.weight)/100,2) as task_weight,
    et.number_of_members,
    to_char(et.due_date, 'YYYY-MM-DD HH24:MI:SS') as due_date_ansi, 
    et.online_p
    from evaluation_grades eg,
    evaluation_tasks et, cr_items cri
    where eg.grade_id = :grade_id
    and eg.grade_item_id = et.grade_item_id
    and cri.live_revision = et.task_id
    $orderby

      </querytext>
</fullquery>

</queryset>
