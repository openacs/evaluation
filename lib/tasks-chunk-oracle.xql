<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_group_id">      
      <querytext>
	select evaluation.party_id(:user_id,:task_id) from dual
      </querytext>
</fullquery>

<fullquery name="answer_info">      
      <querytext>
      select ea.answer_id
      from evaluation_answers ea, cr_items cri
      where ea.task_item_id = :task_item_id 
      and cri.live_revision = ea.answer_id
      and ea.party_id = evaluation.party_id(:user_id,:task_id)
      </querytext>
</fullquery>

</queryset>
