<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_student_name">      
      <querytext>

		select last_name ||', '|| first_names from persons where person_id=:student_id

      </querytext>
</fullquery>

</queryset>
