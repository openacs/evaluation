<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_task_info">      
      <querytext>

	    select et3.task_name,
   	 	count(ets.solution_id) as task_sols,
	    count(ea.answer_id) as task_answers
    	from evaluation_tasks et3,
		evaluation_tasks et2 left outer join evaluation_tasks_solsi ets on (ets.task_id = et2.task_id and content_revision__is_live(ets.solution_id) = true),
		evaluation_tasks et left outer join evaluation_answersi ea on (ea.task_id = et.task_id and content_revision__is_live(ea.answer_id) = true)
		where et3.task_id = :task_id
    	group by et3.task_name
	
      </querytext>
</fullquery>

</queryset>
