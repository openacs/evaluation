<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="associate_student">      
      <querytext>
	begin
		:1 := evaluation.evaluation_group_member_add (
		p_evaluation_group_id => :evaluation_group_id,
		p_user_id => :student_id,
		p_package_id => :package_id,
		p_creation_user_id => :creation_user_id,
		p_creation_ip => :creation_ip
		);
	end;
      </querytext>
</fullquery>

</queryset>
