<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @one_group:rowcount@ gt 0>
  <blockquote>
  <table>
   <tr>
   <td><listtemplate name="one_group"></listtemplate></td>
   <td>
   <h1>Number of Members <br /> of this group: 
   @number_of_members@</h1>
   </td>
   </tr>
  </table>
  </blockquote>
</if>
<else>
  There are no studens associated with this group.
</else>


