

-- deleting calendar mappings
create function inline_0 ()
returns integer as '
declare
    v_cal_item_cursor RECORD;
        
begin

    FOR v_cal_item_cursor IN
        select map.cal_item_id
	from evaluation_tasks et,
	evaluation_cal_task_map map
	where et.task_item_id = map.task_item_id
    LOOP
	delete from evaluation_cal_task_map where cal_item_id = v_cal_item_cursor.cal_item_id;
	PERFORM cal_item__delete (v_cal_item_cursor.cal_item_id);
    END LOOP;

    return 0;
end;
' language 'plpgsql';


select inline_0 ();
drop function inline_0 ();

drop index evaluation_cal_task_map_tcid_index;

drop table evaluation_cal_task_map;

