<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<table align="center">
<tr>
	<th>#evaluation.Task_Name#</th>
	<td>@task_name@</td>
</tr>
<tr>
	<th>#evaluation.Due_Date#</th>
	<td>@due_date_pretty@</td>
</tr>
<tr>
	<th>#evaluation.lt_Is_the_task_submitted#</th>
	<td>

<if @online_p@ eq t >
	<h2> #evaluation.Yes# </h2>
</if><else>
	<h2> #evaluation.No# </h2>
</else>

</td>
</tr>
<tr>
	<th>@groups_admin;noquote@</th>
	<td></td>
</tr>
</table>

<h2>#evaluation.lt_Evaluated_Students_to#</h2>
<p>#evaluation.Theese#</p>
<blockquote><listtemplate name="evaluated_students"></listtemplate></blockquote>
<br />
<h2>#evaluation.lt_Students_with_answers#</h2>
<p>#evaluation.lt_These_are_the_student#</p>

<if @not_evaluated_wa:rowcount@ gt 0>
<p>#evaluation.Click# <a href=download-archive/?task_id=@task_id@>#evaluation.here#</a> #evaluation.lt_if_you_want_to_downlo#</p>
<if @number_of_members@ eq "1">
 <if @show_portrait_p@ eq "t">
	<p>#evaluation.Click# <a href=@this_url@> #evaluation.here# </a> #evaluation.lt_if_you_do_not_want_to#</p>
 </if><else>
	<p>#evaluation.Click# <a href=@this_url@> #evaluation.here# </a> #evaluation.lt_if_you_want_to_see_th#</p>
 </else>
</if><else>
<p>#evaluation.If#</p>
</else>
<form action="evaluate-students" method="post">
    <input type=hidden name=task_id value="@task_id@">
    <input type=hidden name=grade_id value="@grade_id@">
	<blockquote>
	<listtemplate name="not_evaluated_wa"></listtemplate>
    <input type=submit value="#evaluation.Grade_1#">
    </blockquote>
</form>
<blockquote>
  <form name="grades_sheet_form" enctype="multipart/form-data" method="POST" action="grades-sheet-parse.tcl">  
    <input type="hidden" name="grades_sheet_item_id" value=@grades_sheet_item_id@> 
    <input type="hidden" name="task_id" value=@task_id@> 
       <table> 
          <tr> 
          <th style="text-align:right;">#evaluation.lt_Grade_students_using_#</th> 
          <td><input type="file" name="upload_file"></td> 
          <td colspan=2 style="text-align:right;"><input type="submit" value="#evaluation.Send#"></td> 
          </tr> 
          <tr> 
          <td><a href="grades-sheet-csv-@task_id@.csv">#evaluation.Generate_file#</a></td> 
          <td><a href="grades-sheets?task_id=@task_id@">#evaluation.lt_See_grades_sheets_ass#</a></td> 
          <td colspan=2><a href="grades-sheet-explanation?task_id=@task_id@">#evaluation.How_does_this_work#</a></td> 
          </tr> 
       </table> 
  </form> 
</blockquote>
</if><else>
<p>#evaluation.lt_There_are_no_students#</p>
</else>

<br />
<h2>#evaluation.lt_Students_who_have_not#</h2>
<p>#evaluation.lt_These_are_the_student_1#</p>
<if @number_of_members@ eq "1">
 <if @show_portrait_p@ eq "t">
	<p>#evaluation.Click# <a href=@this_url@> #evaluation.here# </a> #evaluation.lt_if_you_do_not_want_to#</p>
 </if><else>
	<p>#evaluation.Click# <a href=@this_url@> #evaluation.here# </a> #evaluation.lt_if_you_want_to_see_th#</p>
 </else>
</if><else>
<p>#evaluation.If#</p>
</else>

<if @not_evaluated_na:rowcount@ gt 0>
<form action="evaluate-students" method="post">
    <input type=hidden name=task_id value=@task_id@>
	<blockquote>
	<listtemplate name="not_evaluated_na"></listtemplate>
	<table width="100%">
	<tr>
	<td align=left><input type=submit value="#evaluation.Grade_1#"></td><td align=right><input type=checkbox name="grade_all">#evaluation.lt_Grade_students_with_0#</td>
	</tr>
	</table>
	</blockquote>
</form>
<br />
<blockquote>
  <form name="grades_sheet_form" enctype="multipart/form-data" method="POST" action="grades-sheet-parse.tcl">  
    <input type="hidden" name="grades_sheet_item_id" value="@grades_sheet_item_id@"> 
    <input type="hidden" name="task_id" value=@task_id@> 
       <table> 
          <tr> 
          <th style="text-align:right;">#evaluation.lt_Grade_students_using_#</th> 
          <td><input type="file" name="upload_file"></td> 
          <td colspan=2 style="text-align:right;"><input type="submit" value="#evaluation.Send#"></td> 
          </tr> 
          <tr> 
          <td><a href="grades-sheet-csv-@task_id@.csv">#evaluation.Generate_file#</a></td> 
          <td><a href="grades-sheets?task_id=@task_id@">#evaluation.lt_See_grades_sheets_ass#</a></td> 
          <td colspan=2><a href="grades-sheet-explanation?task_id=@task_id@">#evaluation.How_does_this_work#</a></td> 
          </tr> 
       </table> 
  </form> 
</blockquote>
</if><else>
<p>#evaluation.lt_There_are_no_students_1#</p>
</else>

