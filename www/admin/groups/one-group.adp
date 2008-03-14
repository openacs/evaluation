<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>


<if @one_group:rowcount@ gt 0>
<ul>
<li>#evaluation.lt_To_chanche_the_name_e#</li>
<li>#evaluation.lt_To_delete_the_group_c#</li>
<li>#evaluation.lt_To_unassociate_a_memb# #evaluation.Note# </li>
</ul>

   <form action="group-rename">
   @export_vars;noquote@
   <blockquote>
   	<table>
	<tr><th align="right">#evaluation.Group_name#</th>
	<td><input type="text" name="group_name" value="@group_name@" size=20></td>
	<td><input type=submit value="#evaluation.Rename#"></td>
	</tr>
   </form>
  	 <tr>
  	 <td><listtemplate name="one_group"></listtemplate></td>
  	 <td>
  	 <h2>#evaluation.lt_Number_of_members_of_# <br> 
  	 @number_of_members@</h2>
  	 </td>
	 <td></td>
  	 </tr>
     </table>
   </blockquote>
</if>
<else>
  #evaluation.lt_There_are_no_studens_#
</else>



