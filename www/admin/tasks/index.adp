<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<property name="context">@context;literal@</property>
<if @simple_p;literal@ true>
<h1 class=blue>#evaluation.Evaluations#</h1>
<br>
<ul>
      <li class="arrow"><a href="grades/grades"><text class="blue"><strong>#evaluation-portlet.lt_Admin_my_Assignment_T#</strong></text></a><br></li>
	<text class="blue">#evaluation-portlet.admin_help#</text></li><br>
      <li class="arrow"><a href="grades/grades-reports"><text class="blue"><strong>#evaluation-portlet.view_students_grades#</strong></text></a><br>
	<text class="blue">#evaluation-portlet.view_grades_help#</text></li><br>
      <li class="arrow"><text class="blue"><strong>Notifications</strong></text>
	<br>
      <text class="blue">@assignments_notification_chunk;noquote@</text></li> 
<br>
<br>
</if>
<else>
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
	<li><strong>@grades.grade_plural_name;noquote@</strong> <br>
	<include src="/packages/evaluation/lib/tasks-chunk" grade_item_id="@grades.grade_item_id;literal@" grade_id="@grades.grade_id;literal@" assignments_orderby="@assignments_orderby;literal@">
        <br><br>
	</li>
</multiple>
</else>
</ul>
<br>
<h2>#evaluation.Evaluations#</h2>
<p>@evaluations_notification_chunk;noquote@</p>
</else>
<ul>
<if @grades:rowcount@ eq 0>
<li>#evaluation.lt_There_are_no_tasks_to#</li>
</if><else>
<multiple name="grades">
	<if @simple_p;literal@ false>
	<li><strong>@grades.grade_plural_name;noquote@</strong> <br>
	</if>
	<include src="/packages/evaluation/lib/evaluations-chunk" grade_item_id="@grades.grade_item_id;literal@" grade_id="@grades.grade_id;literal@" evaluations_orderby="@evaluations_orderby;literal@">
        <br><br>
	</li>
</multiple>
</else>
</ul>


