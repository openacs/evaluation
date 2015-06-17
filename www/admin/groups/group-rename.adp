<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<form action="group-rename-2">
@export_vars;noquote@

<table>
<tr><th>#evaluation.lt_Please_enter_the_new_#</th>
	<td><input type="text" name="group_name" value="@group_name@" size=20></td>
</tr>
<tr>
<td><br><input type="submit" value="#evaluation.Rename#"></td>
<td></td>
</tr>
</table>
</form>
</if>

