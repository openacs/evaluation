<?xml version="1.0"?>

<queryset>
<fullquery name="get_grade_info">      
      <querytext>
	select grade_plural_name, weight as grade_weight from evaluation_grades where grade_id = :grade_id
      </querytext>
</fullquery>

<fullquery name="get_tasks_admin">      
      <querytext>
	select et.task_name, 
	round(et.weight,2) as task_weight,
    et.task_id
	from evaluation_tasksi et, cr_items cri
	where grade_item_id = :grade_item_id
	  and cri.live_revision = et.task_id
      $evaluations_orderby
      </querytext>
</fullquery>

<fullquery name="get_grade_tasks">      
      <querytext>
	select et.task_name, 
	et.task_item_id,
	et.weight as t_weight,
	eg.weight as g_weight,
	round((et.weight*eg.weight)/100,2) as task_weight,
	et.number_of_members,
        et.task_id
	from evaluation_grades eg,
	evaluation_tasksi et,
	cr_items cri
	where eg.grade_id = :grade_id
	and eg.grade_item_id = et.grade_item_id
	and cri.live_revision = et.task_id
	$evaluations_orderby
      </querytext>
</fullquery>

</queryset>

