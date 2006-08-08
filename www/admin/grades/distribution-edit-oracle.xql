<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_grade_tasks">      
      <querytext>

		select et.task_item_id,
		et.task_name, 
		et.weight as task_weight,
		et.requires_grade_p,
		et.task_id,
 		et.points,
		nvl(et.relative_weight,0) as relative_weight,
		cri.live_revision
		from evaluation_tasksi et, cr_items cri
		where et.grade_item_id = :grade_item_id
		and (cri.live_revision = et.task_id or cri.latest_revision = et.task_id)
		and cri.item_id = et.task_item_id
   		order by task_name 

      </querytext>
</fullquery>

</queryset>
