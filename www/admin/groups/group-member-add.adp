<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<if @evaluation_groups:rowcount@ gt 0>
  <h2>#evaluation.lt_Please_select_the_gro#</h2>
  <listtemplate name="evaluation_groups"></listtemplate>
</if>
<else>
  <p>#evaluation.There#</p>
</else>



