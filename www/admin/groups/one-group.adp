<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>


<if @one_group:rowcount@ gt 0>
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
  	 <h1>Number of Members <br /> of this group: 
  	 @number_of_members@</h1>
  	 </td>
	 <td></td>
  	 </tr>
     </table>
   </blockquote>
</if>
<else>
  There are no studens associated with this group.
</else>


