<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="count_grades_sheets">      
      <querytext>

		select count(*) from evaluation_grades_sheets where task_id = :task_id and content_revision__is_live(grades_sheet_id) = true

      </querytext>
</fullquery>

<fullquery name="grades_sheets">      
      <querytext>

	select egs.title as grades_sheet_name,
	to_char(egs.creation_date,'Month DD YYYY') as upload_date,
	person__name(egs.creation_user) as upload_user,
	egs.data as sheet_data,
	egs.revision_id
	from evaluation_grades_sheetsi egs
	where egs.task_id = :task_id 
	  and content_revision__is_live(egs.grades_sheet_id) = true
	$orderby

      </querytext>
</fullquery>

</queryset>
