<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @evaluated_students:rowcount@ gt 0>
   <form action="evaluate-students">
      <input type=hidden name=task_id value="@task_id@">
	   <blockquote><listtemplate name="evaluated_students"></listtemplate></blockquote>
        <input type=submit value="Edit Grades">
    </form>
</if><else>
<p>There are no grades to edit
</else>
</p>