<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.4</version></rdbms>

<fullquery name="get_party_id">      
      <querytext>
	
		select evaluation__party_id(:user_id,:task_id)	
	
      </querytext>
</fullquery>

<fullquery name="late_turn_in">      
      <querytext>
	
	select late_submit_p from evaluation_tasks where task_id = :task_id
	
      </querytext>
</fullquery>

<fullquery name="item_data">      
      <querytext>
	
		select crr.title, crr.item_id
		from evaluation_answers ea, cr_revisions crr
		where ea.answer_id = :answer_id
          and crr.revision_id = ea.answer_id
	
      </querytext>
</fullquery>

<fullquery name="lob_content">      
      <querytext>
	
		update cr_revisions	
 		set lob = [set __lob_id [db_string get_lob_id "select empty_lob()"]]
		where revision_id = :revision_id
 	
      </querytext>
</fullquery>

<fullquery name="link_content">      
      <querytext>
	
		update cr_revisions	
		set content = :url
		where revision_id = :revision_id

      </querytext>
</fullquery>

</queryset>
