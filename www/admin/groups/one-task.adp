<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<p>In this page you can administer the groups for the assignment.</p>
<ul>
<li>First, you will see the list of students without group (if there are students without group) and you can create a group by selecting the members of the group and then clicking on the "Create Group" botton.</li>
<li>You can also add a student to an existing group by clicking on the "Associate to group..." link. Here you will be asked to select the group to wich you want to add the user.</li>
<li>Also, you will see the list of already created groups (if there are any created groups). Click on the "Group administration" link in order to administer the group. In this administration pages you will be able to unassociate members of a given group, rename the group and/or delete the group.</li>
</ul>

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
		<h2>Number of members for this task: <br /> 
		@n_of_members@</h2>
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


