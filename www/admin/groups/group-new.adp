<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @students:rowcount@ gt 0>
<form action="group-new-2">
@export_vars;noquote@

<table>
<tr><th>#evaluation.lt_Please_enter_the_grou#</th>
	<td><input type="text" name="group_name" value="#evaluation.Group#"></td>
		<td></td>
		</tr>
</table>
</form>
</if>

