<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<table align="center">
<tr>
	<th>Task Name:</th>
	<td>@task_name@</td>
</tr>
<tr>
	<th>Due Date:</th>
	<td>@due_date@</td>
</tr>
<tr>
	<th>@groups_admin;noquote@</th>
	<td></td>
</tr>
</table>

<h2>Evaluated Students (@total_evaluated@)</h2>
<blockquote><listtemplate name="evaluated_students"></listtemplate></blockquote>
<br />
<h2>Students with answers that have not been evaluated (@not_evaluated_with_answer@)</h2>

<if @not_evaluated_wa:rowcount@ gt 0>
<form action="evaluate-students" method="post">
    <input type=hidden name=task_id value="@task_id@">
    <input type=hidden name=grade_id value="@grade_id@">
	<blockquote>
	<listtemplate name="not_evaluated_wa"></listtemplate>
    </blockquote>
    <input type=submit value="Grade Students">
</form>
</if><else>
<p>There are no students to eval that already answered</p>
</else>


<br />
<h2>Students who have not submitted answers and have not been evaluated (@not_evaluated_with_no_answer@)</h2>

<if @not_evaluated_na:rowcount@ gt 0>
<form action="evaluate-students" method="post">
    <input type=hidden name=task_id value="@task_id@">
    <input type=hidden name=grade_id value="@grade_id@">
	<blockquote>
	<listtemplate name="not_evaluated_na"></listtemplate>
    </blockquote>
	<table width="100%">
	<tr>
	<td align=left><input type=submit value="Grade Students"></td><td align=right><input type=checkbox name="grade_all">Grade students with 0</td>
	</tr>
	</table>
</form>
</if><else>
<p>There are no students to eval with no answer</p>
</else>
