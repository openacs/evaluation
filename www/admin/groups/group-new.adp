<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @students:rowcount@ gt 0>
<form action="group-new-2">
@export_vars;noquote@

<table>
<tr><th>#evaluation.lt_Please_enter_the_grou#</th>
	<td><input type="text" name="group_name" value="Group @current_groups_plus_one@" size=20></td>
</tr>
<tr>
      <input type=hidden name=task_id value="@task_id@">
      <input type=hidden name=evaluation_group_id value="@evaluation_group_id@">
		<blockquote>
	 	<td></td>
		<td>
        <table>
          <multiple name="students">
                <if @students.rownum@ odd><tr class="list-odd"></if><else><tr class="list-even"></else>
						<td>@students.rownum@.</td><td>@students.student_name@</td></tr>
                    </tr>
          </multiple>
        </table>
		</td>
		</tr>
		<tr>
        <td><input type=submit value="#evaluation.Create#"></td>
		<td></td>
		</tr>
</table>
</form>
</if>

