<?xml version="1.0"?>

<queryset>

<fullquery name="evaluation::get_user_portrait.user_portrait">      
      <querytext>

	select c.item_id
         from acs_rels a, cr_items c
         where a.object_id_two = c.item_id
           and a.object_id_one = :user_id
           and a.rel_type = 'user_portrait_rel'

      </querytext>
</fullquery>

<fullquery name="evaluation::set_points.get_grade_tasks">      
      <querytext>

		select et.task_id, 
		et.weight as task_weight
		from evaluation_tasksi et
		where et.grade_item_id = (select item_id from cr_revisions where revision_id=:grade_id)
		and content_revision__is_live(et.task_id) = true
	
      </querytext>
</fullquery>

<fullquery name="evaluation::set_points.get_grades">      
      <querytext>

		select grade_id, weight
		from evaluation_grades
      </querytext>
</fullquery>

<fullquery name="evaluation::set_points.update_task">      
      <querytext>
	update evaluation_tasks set points=:points 
	where task_id=:task_id	

      </querytext>
</fullquery>

<fullquery name="evaluation::set_perfect_score.get_tasks">      
      <querytext>
	select task_id from evaluation_tasks

      </querytext>

</fullquery>

<fullquery name="evaluation::set_perfect_score.update_task">      
      <querytext>
	update evaluation_tasks set perfect_score=:perfect_score 
	where task_id=:task_id	
      </querytext>
</fullquery>

<fullquery name="evaluation::set_relative_weight.get_tasks">      
      <querytext>
	select task_id from evaluation_tasks

      </querytext>

</fullquery>

<fullquery name="evaluation::set_relative_weight.update_task">      
      <querytext>
	update evaluation_tasks set relative_weight=:relative_weight 
	where task_id=:task_id	
      </querytext>
</fullquery>

<fullquery name="evaluation::set_forums_related.get_tasks">      
      <querytext>
	select task_id from evaluation_tasks

      </querytext>

</fullquery>

<fullquery name="evaluation::set_forums_related.update_task">      
      <querytext>
	update evaluation_tasks set forums_related_p=:forums_related_p 
	where task_id=:task_id	
      </querytext>
</fullquery>
	


 
</queryset>
