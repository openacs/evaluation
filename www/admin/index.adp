<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<h2>Assignment Types</h2>
<ul>
<li><a href="grades/grades">Admin my Assignment Types</a></li>
</ul>

<h2>Tasks</h2>
<ul>
<if @grades:rowcount@ eq 0>
<li>There are no tasks for this package.</li>
</if><else>
<multiple name="grades">
	<li><strong>@grades.grade_name@</strong> <br />
	<include src="../../lib/tasks-chunk" grade_id=@grades.grade_id@>
	</li>
</multiple>
</else>
</ul>
<br />
<h2>Evaluations</h2>
<ul>
<if @grades:rowcount@ eq 0>
<li>There are no tasks to evaluate for this package.</li>
</if><else>
<multiple name="grades">
	<li><strong>@grades.grade_name@</strong> <br />
	<include src="../../lib/evaluations-chunk" grade_id=@grades.grade_id@>
	</li>
</multiple>
</else>
</ul>
<br />
<h2>Grades Reports</h2>
<ul>
<li><a href="grades/grades-reports">Grades Reports</a></li>
</ul>