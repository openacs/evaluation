<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_task_info">      
      <querytext>

	    select task_name 
        from evaluation_tasks et 
        where task_id=:task_id

      </querytext>
</fullquery>

<fullquery name="file_exists">      
      <querytext>

		select count(*) from cr_items where item_id = :grades_sheet_item_id

      </querytext>
</fullquery>

<fullquery name="get_item_id">      
      <querytext>

		select item_id from evaluation_student_evalsi where evaluation_id = :evaluation_id

      </querytext>
</fullquery>

</queryset>
