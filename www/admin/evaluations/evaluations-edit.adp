<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<if @evaluated_students:rowcount@ gt 0>
  <form action="evaluate-students" method="POST">
      <div><input type="hidden" name="task_id" value="@task_id@"></div>
		@export_vars;noquote@
	   <listtemplate name="evaluated_students"></listtemplate>
       <div><input type="submit" value="#evaluation.Edit#"></div>
  </form>

  <form name="grades_sheet_form" enctype="multipart/form-data" method="POST" action="grades-sheet-parse.tcl">  
    <div>
    <input type="hidden" name="grades_sheet_item_id" value="@grades_sheet_item_id@"> 
    <input type="hidden" name="task_id" value="@task_id@"> 
    </div>
       <table> 
          <tr> 
          <th style="text-align:right;">#evaluation.lt_Grade_students_using_file#</th> 
          <td><input type="file" name="upload_file"></td> 
          <td colspan="2" style="text-align:right;"><input type="submit" value="#evaluation.Send#"></td> 
          </tr> 
          <tr> 
          <td><a href="grades-sheet-csv-@task_id@.csv">#evaluation.Generate_file#</a></td> 
          <td><a href="grades-sheets?task_id=@task_id@&amp;return_url=evaluations-edit">#evaluation.lt_See_grades_sheets_ass#</a></td> 
          <td colspan="2"><a href="grades-sheet-explanation?task_id=@task_id@">#evaluation.How_does_this_work#</a></td> 
          </tr> 
       </table> 
  </form> 

</if><else>
<p>#evaluation.lt_There_are_no_edit#</p>
</else>


