<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @admin_p@ eq 1>
	<a href=admin/index>Evaluations Admin</a>
</if>

<h2>Assignments</h2><br />
<p>@notification_chunk;noquote@</p>
<ul>
<if @grades:rowcount@ eq 0>
<li>There are no tasks for this package.</li>
</if><else>
<multiple name="grades">
	<li><strong>@grades.grade_plural_name@</strong> <br />
	<include src="../lib/tasks-chunk" grade_id=@grades.grade_id@ assignments_orderby=@assignments_orderby@>
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
	<li><strong>@grades.grade_plural_name@</strong> <br />
	<include src="../lib/evaluations-chunk" grade_id=@grades.grade_id@ evaluations_orderby=@evaluations_orderby@>
	</li>
 </multiple>
 <if @admin_p@ eq "0">
 <br />Your total grade in this class is: <strong>@total_class_grade@</strong>
 </if>
</else>
</ul>
