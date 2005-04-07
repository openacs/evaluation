-- jopez@galileo.edu
-- cesarhj@galileo.edu
-- deleting calendar mappings      
begin
    FOR row in(select map.cal_item_id
	from evaluation_tasks et,
	evaluation_cal_task_map map
	where et.task_item_id = map.task_item_id)
    LOOP
	delete from evaluation_cal_task_map where cal_item_id = row.cal_item_id;
	cal_item.del(cal_item_id => row.cal_item_id);
    END LOOP;
end;
/
show errors;

drop index ev_cal_task_map_tcid_index;
drop table evaluation_cal_task_map;


