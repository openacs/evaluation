<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<form action="group-rename-2">
@export_vars;noquote@

<table>
<tr><th>Please enter the new group name</th>
	<td><input type="text" name="group_name" value="@group_name@" size=20></td>
</tr>
<tr>
<td><br /><input type=submit value="Rename Group"></td>
<td></td>
</tr>
</table>
</form>
</if>
