<?xml version="1.0"?>

<queryset>

<fullquery name="grade_info">      
      <querytext>

	select eg.grade_plural_name,
		eg.weight as grade_weight,
		eg.grade_item_id,
		eg.comments as grade_comments
		from evaluation_gradesi eg
		where grade_id = :grade_id
	
      </querytext>
</fullquery>

</queryset>
