<master>
  <property name="title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>

<if @communities_count@ gt 0>
<p>The assignment "@task_name@" has been uploaded in this community. <br />Check the rest of communities where you want to upload the assignment too</p>
<blockquote><formtemplate id="communities"></formtemplate></blockquote>
</if><else>
There are no more communities where you can add the task. <br />
If you administer more than one community and you want to upload an assigment in more than one community, you must set the same name for each of the assignment types in each community so the system can identify where to store the assignment.
</else>
