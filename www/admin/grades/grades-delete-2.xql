<?xml version="1.0"?>

<queryset>


<fullquery name="cal_map">      
      <querytext>

	    select map.cal_item_id
	    from evaluation_tasks et,
	    evaluation_grades eg,
	    evaluation_cal_task_map map
	    where eg.grade_id = :grade_id
	    and et.grade_item_id = eg.grade_item_id
	    and et.task_item_id = map.task_item_id
	
      </querytext>
</fullquery>

<fullquery name="delete_mapping">      
      <querytext>

		delete from evaluation_cal_task_map where cal_item_id = :cal_item_id
	    
      </querytext>
</fullquery>


</queryset>
