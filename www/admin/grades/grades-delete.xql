<queryset>

<fullquery name="get_grade_info">      
      <querytext>

    select item_id,
	grade_plural_name
    from evaluation_gradesx
	where grade_id = :grade_id

      </querytext>
</fullquery>

</queryset>

