
DO $$
BEGIN

   update acs_attributes set
      datatype = 'boolean'
    where object_type = 'evaluation_student_evals'
      and attribute_name = 'show_student_p';

   update acs_attributes set
      datatype = 'boolean'
    where object_type = 'evaluation_tasks'
      and attribute_name in ('online_p', 'late_submit_p', 'requires_grade_p', 'forums_related_p');

   update acs_attributes set
      datatype = 'number'
    where object_type = 'evaluation_tasks'
      and attribute_name = 'number_of_members';

   update acs_attributes set
      datatype = 'string'
    where object_type = 'evaluation_tasks'
      and attribute_name = 'task_name';

END$$;
