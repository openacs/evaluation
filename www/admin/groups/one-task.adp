<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<p>#evaluation.lt_In_this_page_you_can_#</p>
<ul>
<li>#evaluation.lt_First_you_will_see_th#</li>
<li>#evaluation.lt_You_can_also_add_a_st#</li>
<li>#evaluation.lt_Also_you_will_see_the#</li>
</ul>

<if @students_without_group:rowcount@ gt 0>
	<table width="100%">
		<tr>
		<td align="right">@reuse_link;noquote@</td>
		</tr>
	</table>
	<form action="group-new">
	<div><input type="hidden" name="task_id" value="@task_id@"></div>

	<table>
		<tr>
		<td><input type="submit" value="#evaluation.Create_Group_#"></td>
		<td><listtemplate name="students_without_group"></listtemplate></td>
		<td>
		<h2>#evaluation.lt_Number_of_members_for# <br> 
		@n_of_members@</h2>
		</td>
		</tr>
	</table>

	</form>
</if>

<if @task_groups:rowcount@ gt 0>
	<a name="groups">
	<h2>#evaluation.lt_Already_created_group#</h2>

	<listtemplate name="task_groups"></listtemplate>

</if>

<if @return_url@ not nil>
<p><a href="@return_url@">#evaluation.Go#</a></p>
</if>

