<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @students_without_group:rowcount@ gt 0>
	<table width="100%">
		<tr>
		<td align=right>@reuse_link;noquote@</td>
		</tr>
	</table>
	<form action="group-new"
	<input type=hidden name=task_id value="@task_id@">
	<blockquote>
	<table>
		<tr>
		<td><input type=submit value="Create Group"></td>
		<td><listtemplate name="students_without_group"></listtemplate></td>
		<td>
		<h1>Number of Members <br /> 
		@n_of_members@</h1>
		</td>
		</tr>
	</table>
	</blockquote>
	</form>
</if>

<if @task_groups:rowcount@ gt 0>
	<h2>Already created groups</h2>
	<blockquote>
	<listtemplate name="task_groups"></listtemplate>
	</blockquote>
</if>


