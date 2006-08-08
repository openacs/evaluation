<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_groups">      
      <querytext>

	select et.task_name, et.number_of_members,
    et.task_id as from_task_id,
    eg.grade_plural_name
	from evaluation_tasks et, evaluation_grades eg, acs_objects ao, cr_items cri1, cr_items cri2
	where et.number_of_members > 1
      and et.grade_item_id = eg.grade_item_id
      and cri1.live_revision = eg.grade_id
      and cri2.live_revision = et.task_id
      and ao.object_id = eg.grade_item_id
      and ao.context_id = :package_id
      and et.task_id <> :task_id
      $orderby
	
      </querytext>
</fullquery>

</queryset>
