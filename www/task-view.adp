<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<table>
<tr>
  <th align=right>#evaluation.Task_Name_1#<th>
  <td>@task_name@</td>
</tr>
<tr>
  <th align=right>#evaluation.Description#<th>
  <td>@description;noquote@</td>
</tr>
<tr>
  <th align=right>#evaluation.Due_Date_1#<th>
  <td>@due_date@</td>
</tr>
<tr>
  <th align=right>#evaluation.Fileurl_associated#<th>
  <td>@task_url@</td>
</tr>
<tr>
  <th align=right>#evaluation.Number_of_Integrants#<th>
  <td>@number_of_members@</td>
</tr>
<tr>
  <th align=right>#evaluation.Weight#<th>
  <td>@weight@%</td>
</tr>
<tr>
  <th align=right>#evaluation.Grades_Category#<th>
  <td>@grade_plural_name@ - @grade_weight@%</td>
</tr>
<tr>
  <th align=right>#evaluation.lt_Will_this_task_be_sub#<th>
  <td>@online_p@</td>
</tr>
<tr>
  <th align=right>#evaluation.lt_Will_the_students_be_# <br> #evaluation.lt_to_submit_their_answe#<th>
  <td>@late_submit_p@</td>
</tr>
<tr>
  <th align=right>#evaluation.Task_Solution#<th>
  <td>@solution_url;noquote@</td>
</tr>


</table>

<if @return_url@ ne "">
  <p><a href=@return_url@>#evaluation.Go_Back#</a></p>
</if>


