<?xml version="1.0"?>

<queryset>


<fullquery name="get_item_id">      
      <querytext>

	    select task_item_id
	    from evaluation_tasks
	    where task_id = :task_id
	
      </querytext>
</fullquery>

<fullquery name="cal_map">      
      <querytext>

	   select cal_item_id
	   from evaluation_cal_task_map
	   where task_item_id = :task_item_id
	
      </querytext>
</fullquery>

<fullquery name="delete_mapping">      
      <querytext>

	delete from evaluation_cal_task_map where cal_item_id = :cal_item_id
	    
      </querytext>
</fullquery>

</queryset>
