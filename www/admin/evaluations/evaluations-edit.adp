<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @evaluated_students:rowcount@ gt 0>
  <form action="evaluate-students">
      <input type=hidden name=task_id value="@task_id@">
	   <blockquote><listtemplate name="evaluated_students"></listtemplate></blockquote>
        <input type=submit value="Edit Grades">
  </form>
  <blockquote>
  <form name="grades_sheet_form" enctype="multipart/form-data" method="POST" action="grades-sheet-parse.tcl">  
    <input type="hidden" name="grades_sheet_item_id" value="@grades_sheet_item_id@"> 
    <input type="hidden" name="task_id" value=@task_id@> 
       <table> 
          <tr> 
          <th style="text-align:right;">Grade students using generated file:</th> 
          <td><input type="file" name="upload_file"></td> 
          <td colspan=2 style="text-align:right;"><input type="submit" value="Send file"></td> 
          </tr> 
          <tr> 
          <td><a href="grades-sheet-csv-@task_id@.csv">Generate file</a></td> 
          <td><a href="grades-sheets?task_id=@task_id@">See grades sheets associated with this task</a></td> 
          <td colspan=2><a href="grades-sheet-explanation?task_id=@task_id@">How does this work?</a></td> 
          </tr> 
       </table> 
  </form> 
  </blockquote>
</if><else>
<p>There are no grades to edit
</else>
</p>