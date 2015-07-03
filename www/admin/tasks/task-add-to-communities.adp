<master>
  <property name="doc(title)">@page_title;literal@</property>
  <property name="context">@context;literal@</property>

<if @communities_count@ gt 0>
<p>#evaluation.lt_The_assignment_task_n# <br>#evaluation.lt_Check_the_rest_of_com#</p>
<formtemplate id="communities"></formtemplate>
</if>

