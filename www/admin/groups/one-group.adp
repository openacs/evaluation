<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>


<if @one_group:rowcount@ gt 0>
<ul>
<li>To chanche the name, edit the name in the text input and then click on the "Rename Group" botton.
<li>To delete the group, click on the "Delete Group" botton.
<li>To unassociate a member of the group, click on the "Unassociate member" link.
</ul>

   <form action="group-rename">
   @export_vars;noquote@
   <blockquote>
   	<table>
	<tr><th align="right">Group name</th>
	<td><input type="text" name="group_name" value="@group_name@" size=20></td>
	<td><input type=submit value="Rename Group"></td>
	</tr>
   </form>
  	 <tr>
  	 <td><listtemplate name="one_group"></listtemplate></td>
  	 <td>
  	 <h2>Number of members of this group: <br /> 
  	 @number_of_members@</h2>
  	 </td>
	 <td></td>
  	 </tr>
     </table>
   </blockquote>
</if>
<else>
  There are no studens associated with this group.
</else>


