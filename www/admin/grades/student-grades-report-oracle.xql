<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="student_info">      
      <querytext>

	select person.name(:student_id) as student_name,
                      p.email
                      from parties p
                      where p.party_id = :student_id

      </querytext>
</fullquery>

<fullquery name="get_total_grade">      
      <querytext>

	select evaluation.class_total_grade(:student_id,:package_id) from dual

      </querytext>
</fullquery>

</queryset>
