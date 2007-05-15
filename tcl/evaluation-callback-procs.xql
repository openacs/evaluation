<?xml version="1.0"?>

<queryset>

  <fullquery name="callback::merge::MergeShowUserInfo::impl::evaluation.sel_answers">
    <querytext>	
      select answer_id
      from evaluation_answers
      where party_id = :user_id
    </querytext>
  </fullquery>
  
  <fullquery name="callback::merge::MergeShowUserInfo::impl::evaluation.sel_evals">
    <querytext>	
      select evaluation_id, grade 
      from evaluation_student_evals
      where party_id = :user_id
    </querytext>
  </fullquery>
	
  <fullquery name="callback::merge::MergePackageUser::impl::evaluation.upd_from_answers">
    <querytext>	
      update evaluation_answers
      set party_id = :to_user_id
      where party_id = :from_user_id
    </querytext>
  </fullquery>
  
  <fullquery name="callback::merge::MergePackageUser::impl::evaluation.upd_from_stud_evals">
    <querytext>	
      update evaluation_student_evals
      set party_id = :to_user_id
      where party_id = :from_user_id
    </querytext>
  </fullquery>
  
</queryset>
