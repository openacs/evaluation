<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<h2>#evaluation.Assignment_Types#</h2>
<ul>
<li><a href="grades/grades">#evaluation.lt_Admin_my_Assignment_T#</a></li>
</ul>
<h2>#evaluation.Grades_Reports#</h2>
<ul>
<li><a href="grades/grades-reports">#evaluation.Grades_Reports#</a></li>
</ul>
<h2>#evaluation.Assignments#</h2>
<p>@assignments_notification_chunk;noquote@</p>
<ul>
<if @grades:rowcount@ eq 0>
<li>#evaluation.lt_There_are_no_tasks_fo#</li>
</if><else>
<multiple name="grades">
	<li><strong>@grades.grade_plural_name;noquote@</strong> <br />
	<include src="../../lib/tasks-chunk" grade_item_id=@grades.grade_item_id@ grade_id=@grades.grade_id@ assignments_orderby=@assignments_orderby@>
	</li>
</multiple>
</else>
</ul>
<br />
<h2>#evaluation.Evaluations#</h2>
<p>@evaluations_notification_chunk;noquote@</p>
<ul>
<if @grades:rowcount@ eq 0>
<li>#evaluation.lt_There_are_no_tasks_to#</li>
</if><else>
<multiple name="grades">
	<li><strong>@grades.grade_plural_name;noquote@</strong> <br />
	<include src="../../lib/evaluations-chunk" grade_item_id=@grades.grade_item_id@ grade_id=@grades.grade_id@ evaluations_orderby=@evaluations_orderby@>
	</li>
</multiple>
</else>
</ul>


