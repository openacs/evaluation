<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="count_grades_sheets">      
      <querytext>

		select count(*) from evaluation_grades_sheets egs, evaluation_tasks et
		where egs.task_item_id = et.task_item_id 
		and et.task_id = :task_id
		and content_revision.is_live(egs.grades_sheet_id) = 't'

      </querytext>
</fullquery>

<fullquery name="get_grades_sheets">      
      <querytext>

	select egs.title as grades_sheet_name,
	to_char(egs.creation_date, 'YYYY-MM-DD HH24:MI:SS') as upload_date_ansi,
	person.name(egs.creation_user) as upload_user,
	egs.data as sheet_data,
	egs.revision_id
	from evaluation_grades_sheetsi egs,
	evaluation_tasks et
	where egs.task_item_id = et.task_item_id
	  and et.task_id = :task_id 
	  and content_revision.is_live(egs.grades_sheet_id) = 't'
	$orderby

      </querytext>
</fullquery>

</queryset>
