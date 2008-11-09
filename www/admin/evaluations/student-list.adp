<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @simple_p@ eq 1>
<h1 class="blue">@page_title;noquote@</h1>
<br>
<br>
<table>
<tr>
	<td class="blue"><b>#evaluation.name#:</b></td>
	<td class="blue">@task_name@&nbsp;<a class="tlmidnav" href="@task_admin_url@"><b>(#evaluation.edit#)</b></a></td>
</tr>
<tr>
	<td class="blue"><b>#evaluation.Due_Date#:</b></td>
	<td class="blue">@due_date_pretty@</td>
</tr>
<tr>
	<td class="blue"><b>#evaluation.online#:</b></td>
	<td class="blue">

<if @online_p@ eq t >
	 #evaluation.Yes# 
</if><else>
	 #evaluation.No# 
</else>

</td>
</tr>
<tr>
	<td class="blue"><b>#evaluation.Perfect_Score#:</b></td>
	<td class="blue">@perfect_score@</td>
</tr>
<tr>
<if @number_of_members@ eq "1">

 < if @show_portrait_p@ eq "f">
	<td class="blue"><b>#evaluation.view_portraits#</b></td><td class="blue"><b>(<a href="@this_url@">#evaluation.yes_#</b></a>/#evaluation.no_#<b>)</b></td>
< /if><else>
	<td class="blue"><b>#evaluation.view_portraits#</b></td><td class="blue"><b>(</b>#evaluation.yes_#/<b><a href=@this_url@>#evaluation.no_#</a>)</b></td>
 < /else >
</if>
</tr>

<tr>
	<td>@groups_admin;noquote@</td>
</tr>
</table>
<br>
<br>

<div id="evaluations">
<table width="100%" style="border:0px" alt="" cellpadding="0" cellspacing="0" height="40">
  <tr>
    <td valign="middle" width="30%" style="padding-left: 10px;"><text class="blue"><b>#evaluation.lt_Evaluated_Students_to#</b></text></td>
    <td valign="middle" width="67%" align="right" style="font-size: 10px; color: #354785; font-weight: bold;">  
@actions;noquote@
    </td>
  </tr>
</table>
</div>
</if>
<else>

<table style="text-align:center">
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
	<td>@groups_admin;noquote@</td>
	<td>@task_admin;noquote@</a></td>
</tr>
</table>
<br>
<h2>#evaluation.lt_Evaluated_Students_to#</h2>
<p>#evaluation.Theese#</p>
</else>
<listtemplate name="evaluated_students"></listtemplate>
<br>
<if @forums_related_p@ eq f>
<if @simple_p@ eq 1>
<div id="evaluations">
<table width="100%" style="border:0" alt="" cellpadding="0" cellspacing="0" height="40">
  <tr>
    <td valign="middle" width="30%" style="padding-left: 10px;"><text class="blue"><b>#evaluation.lt_Students_with_answers#</b></text></td>
  </tr>
</table>
</div>

</if>
<else>
<h2>#evaluation.lt_Students_with_answers#</h2>
<p>#evaluation.lt_These_are_the_student#</p>
</else>
<if @not_evaluated_wa:rowcount@ gt 0>
<if @simple_p@ eq 0>
<p>#evaluation.Click# <a href="download-archive/?task_id=@task_id@">#evaluation.here#</a> #evaluation.lt_if_you_want_to_downlo#</p>
<if @number_of_members@ eq "1">
 <if @show_portrait_p@ eq "t">
	<p>#evaluation.Click# <a href="@this_url@"> #evaluation.here# </a> #evaluation.lt_if_you_do_not_want_to#</p>
 </if><else>
	<p>#evaluation.Click# <a href="@this_url@"> #evaluation.here# </a> #evaluation.lt_if_you_want_to_see_th#</p>
 </else>
</if><else>
<p>#evaluation.If#</p>
</else>
</if>
<form action="evaluate-students" method="post">
    <div><input type=hidden name=task_id value="@task_id@"></div>
    <div><input type=hidden name=grade_id value="@grade_id@"></div>

	<listtemplate name="not_evaluated_wa"></listtemplate>
    <if @simple_p@ eq 1>
	<br>
    	<div><input type=image src="/resources/evaluation/submit.gif"></div>
    </if>
    <else>
    <div><input type=submit value="#evaluation.Grade_1#"></div>
    </else>
    <div><input type=submit value="#evaluation.Grade_1#"></div>
    </else>

</form>

<if @simple_p@ eq 0>
  <form name="grades_sheet_form" enctype="multipart/form-data" method="POST" action="grades-sheet-parse.tcl">  
    <div><input type="hidden" name="grades_sheet_item_id" value=@grades_sheet_item_id@></div>
    <div><input type="hidden" name="task_id" value=@task_id@></div>
       <table> 
          <tr> 
          <th style="text-align:right;">#evaluation.lt_Grade_students_using_#</th> 
          <td><input type="file" name="upload_file"></td> 
          <td colspan=2 style="text-align:right;"><input type="submit" value="#evaluation.Send#"></td> 
          </tr> 
          <tr> 
          <td><a href="grades-sheet-csv-@task_id@.csv">#evaluation.Generate_file#</a></td> 
          <td><a href="grades-sheets?task_id=@task_id@&return_url=student-list">#evaluation.lt_See_grades_sheets_ass#</a></td> 
          <td colspan=2><a href="grades-sheet-explanation?task_id=@task_id@">#evaluation.How_does_this_work#</a></td> 
          </tr> 
       </table> 
  </form> 
</if>
<else>
<ul>
<li class="arrow"><text class="blue">#evaluation.download#<b><a href="grades-sheet-csv-@task_id@.csv">#evaluation.students_ready#</a></b>#evaluation.spreadsheet#<br></text>
<li class="arrow"><text class="blue">#evaluation.upload_graded##evaluation.students_ready#</text>

  <form name="grades_sheet_form" enctype="multipart/form-data" method="POST" action="grades-sheet-parse.tcl">  
    <div><input type="hidden" name="grades_sheet_item_id" value=@grades_sheet_item_id@></div>
    <div><input type="hidden" name="task_id" value=@task_id@></div>
       <table> 
          <tr> 
          <th style="text-align:right;"><text class="blue">#evaluation.lt_Grade_students_using_#</text></th> 
          <td><input type="file" name="upload_file" src="/resources/evaluation/browse.gif"></td> 
          <td colspan=2 style="text-align:right;"><input type="image" src="/resources/evaluation/upload.gif"></td> 
          </tr> 
         </table>
          
          
  </form> 

<li class="arrow"><a href="grades-sheets?task_id=@task_id@"><text class="blue">#evaluation.lt_See_grades_sheets_ass#</text></a>
<li class="arrow"><a href="grades-sheet-explanation?task_id=@task_id@"><text class="blue">#evaluation.How_does_this_work#</text></a>
</ul>

</else>

</if><else>
<p>#evaluation.lt_There_are_no_students#</p>
</else>

<br>
<if @simple_p@ eq 1>
<div id="evaluations">
<table width="100%" style="border:0px" alt="" cellpadding="0" cellspacing="0" height="40">
  <tr>
    <td valign="middle" width="30%" style="padding-left: 10px;"><text class="blue"><b>#evaluation.lt_Students_who_have_not#</b></text></td>
  </tr>
</table>
</div>
</if>
<else>
<h2>#evaluation.lt_Students_who_have_not#</h2>

<p>#evaluation.lt_These_are_the_student_1#</p>
</else>

<if @not_evaluated_na:rowcount@ gt 0>
<if @simple_p@ eq 0>
<if @number_of_members@ eq "1">
 <if @show_portrait_p@ eq "t">
	<p>#evaluation.Click# <a href=@this_url@> #evaluation.here# </a> #evaluation.lt_if_you_do_not_want_to#</p>
 </if><else>
	<p>#evaluation.Click# <a href=@this_url@> #evaluation.here# </a> #evaluation.lt_if_you_want_to_see_th#</p>
 </else>
</if><else>
<p>#evaluation.If#</p>
</else>
</if>
<form action="evaluate-students" method="post">
    <div><input type=hidden name=task_id value=@task_id@></div>

	<listtemplate name="not_evaluated_na"></listtemplate>
	<table width="100%">
	<tr>
	        <td align=left><if @simple_p@ eq 0><input type=submit value="#evaluation.Grade_1#"></if>
	<else>
	<br>
	<input type=image src="/resources/evaluation/submit.gif">
	</else></td><td align=left><input type=checkbox name="grade_all"><text class=blue>#evaluation.lt_Grade_students_with_0#</text></td>
	</tr>
	</table>

</form>
<br>

<if @simple_p@ eq 0>
  <form name="grades_sheet_form" enctype="multipart/form-data" method="POST" action="grades-sheet-parse.tcl">  
    <div><input type="hidden" name="grades_sheet_item_id" value="@grades_sheet_item_id@"></div>
    <div><input type="hidden" name="task_id" value=@task_id@></div>
       <table> 
          <tr> 
          <th style="text-align:right;">#evaluation.lt_Grade_students_using_#</th> 
          <td><input type="file" name="upload_file"></td> 
          <td colspan=2 style="text-align:right;"><input type="submit" value="#evaluation.Send#"></td> 
          </tr> 
          <tr> 
          <td><a href="grades-sheet-csv-@task_id@.csv">#evaluation.Generate_file#</a></td> 
          <td><a href="grades-sheets?task_id=@task_id@&return_url=student-list">#evaluation.lt_See_grades_sheets_ass#</a></td> 
          <td colspan=2><a href="grades-sheet-explanation?task_id=@task_id@">#evaluation.How_does_this_work#</a></td> 
          </tr> 
       </table> 
  </form> 
</if>
<else>
<ul>
<li class="arrow"><text class="blue">#evaluation.download#<b><a href="grades-sheet-csv-@task_id@.csv">#evaluation.students_without_subm#</a></b>#evaluation.spreadsheet#</text><br>
<li class="arrow"><text class="blue">#evaluation.upload_graded##evaluation.students_without_subm#</text>
</ul>
<br>


  <form name="grades_sheet_form" enctype="multipart/form-data" method="POST" action="grades-sheet-parse.tcl">  
    <div><input type="hidden" name="grades_sheet_item_id" value="@grades_sheet_item_id@"></div>
    <div><input type="hidden" name="task_id" value=@task_id@></div>
       <table> 
          <tr> 
          <th style="text-align:right;"><text class="blue">#evaluation.lt_Grade_students_using_#</text></th> 
          <td><input type="file" name="upload_file"></td> 
          <td colspan=2 style="text-align:right;"><input type="image" src="/resources/evaluation/upload.gif"></td> 
          </tr> 
       </table> 
  </form> 
<li class="arrow"><a href="grades-sheets?task_id=@task_id@"><text class="blue">#evaluation.lt_See_grades_sheets_ass#</text></a>
<li class="arrow"><a href="grades-sheet-explanation?task_id=@task_id@"><text class="blue">#evaluation.How_does_this_work#</text></a>
</ul>
</else>

</if><else>
<p>#evaluation.lt_There_are_no_students_1#</p>
<if @number_of_members@ gt 0 and @total_processed@ eq 0>
<p> #evaluation.lt_task_name_is_in_group# </p>
</if>
</else>
</if>
<else>
<if @simple_p@ eq 1>
<div id="evaluations">
<table width="100%" style="border:0px" alt="" cellpadding="0" cellspacing="0" height="40">
  <tr>
    <td valign="middle" width="30%" style="padding-left: 10px;"><text class="blue"><b>#evaluation.Class_Students#</b></text></td>
  </tr>
</table>
</div>
</if>
<else>
<br>
<h2>#evaluation.Class_Students#</h2>
</else>
<if @students@ gt 0>
< if @number_of_members@ eq "1">
< /if><else>
<p>#evaluation.If#</p>
</else>

<form action="evaluate-students" method="post">
    <div><input type=hidden name=task_id value="@task_id@"></div>
    <div><input type=hidden name=grade_id value="@grade_id@"></div>

	<listtemplate name="class_students"></listtemplate>
	<if @simple_p@ eq 1>
	<br>
	<table width="100%">
	<tr>
	<td align=left><input type=image src="/resources/evaluation/submit.gif"><td>
	<td align=left><input type=checkbox name="grade_all"><text class="blue">#evaluation.lt_Grade_students_with_0#</text></td>
	</tr>
	</table>
        </if>
	<else>
	    <div><input type=submit value="#evaluation.Grade_1#"></div>
        <div><input type=checkbox name="grade_all">#evaluation.lt_Grade_students_with_0#</div>
	</else>

</form>
<if @simple_p@ eq 0>
  <form name="grades_sheet_form" enctype="multipart/form-data" method="POST" action="grades-sheet-parse.tcl">  
    <div><input type="hidden" name="grades_sheet_item_id" value=@grades_sheet_item_id@></div>
    <div><input type="hidden" name="task_id" value=@task_id@></div>
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
</if>
<else>
<ul>
<li class="arrow"><text class="blue">#evaluation.download# <b><a href="grades-sheet-csv-@task_id@.csv">#evaluation.class_students#</a></b>#evaluation.spreadsheet#<br></text>
<li class="arrow"><text class="blue">#evaluation.upload_graded# #evaluation.class_students#</text>

  <form name="grades_sheet_form" enctype="multipart/form-data" method="POST" action="grades-sheet-parse.tcl">  
    <div>
    <input type="hidden" name="grades_sheet_item_id" value=@grades_sheet_item_id@> 
    <input type="hidden" name="task_id" value=@task_id@> 
    </div>
       <table> 
          <tr> 
          <th style="text-align:right;"><text class="blue">#evaluation.lt_Grade_students_using_#</text></th> 
          <td><input type="file" name="upload_file" src="/resources/evaluation/browse.gif"></td> 
          <td colspan=2 style="text-align:right;"><input type="image" src="/resources/evaluation/upload.gif"></td> 
	  
          </tr> 
         </table>
          
          
  </form> 

<li class="arrow"><a href="grades-sheets?task_id=@task_id@"><text class="blue">#evaluation.lt_See_grades_sheets_ass#</text></a>
<li class="arrow"><a href="grades-sheet-explanation?task_id=@task_id@"><text class="blue">#evaluation.How_does_this_work#</text></a>
</ul>
</else>
</if><else>
<p><text class="blue">#evaluation.lt_There_are_no_students#</text></p>
</else>
<br>
</else>
