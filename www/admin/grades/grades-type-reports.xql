<queryset>

<fullquery name="get_tasks">      
      <querytext>

	select count(task_id) from evaluation_tasks et, evaluation_grades eg where eg.grade_id = :grade_id and content_revision__is_live(eg.grade_id) = true and eg.grade_item_id = et.grade_item_id

      </querytext>
</fullquery>

</queryset>

