<queryset>

<fullquery name="get_tasks">      
      <querytext>

	select count(task_id) from evaluation_tasks where grade_id = :grade_id

      </querytext>
</fullquery>

</queryset>

