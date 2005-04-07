<?xml version="1.0"?>

<queryset>

<fullquery name="compare_evaluation_date">      
      <querytext>

	select 1 from dual where :submission_date_ansi  > :evaluation_date_ansi
	
      </querytext>
</fullquery>

<fullquery name="compare_submission_date">      
      <querytext>

	select 1 from dual where :submission_date_ansi > :due_date_ansi
	
      </querytext>
</fullquery>

</queryset>
