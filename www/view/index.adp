<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>
<if @simple_p@ eq 0>
<if @admin_p@ eq 1>
	<a href="admin/index">#evaluation.Evaluations_Admin#</a>
</if>

<h2>#evaluation.Assignments#</h2><br>
<p>@notification_chunk;noquote@</p>
<ul>
<if @grades:rowcount@ eq 0>
<li>#evaluation.lt_There_are_no_tasks_fo#</li>
</if><else>
<multiple name="grades">
	<li><strong>@grades.grade_plural_name;noquote@</strong> <br>
	<include src="/packages/evaluation/lib/tasks-chunk" grade_item_id=@grades.grade_item_id@ grade_id=@grades.grade_id@ assignments_orderby=@assignments_orderby@>
        <br><br>
	</li>
</multiple>
</else>
</ul>
<br>
</if>
<if @simple_p@ eq 0>
<h2>#evaluation.Evaluations#</h2>
</if>
<else>
<h1 class="blue">#evaluation.Evaluations_gradebook#</h1>
</else>
<ul>
<if @grades:rowcount@ eq 0>
<li>#evaluation.lt_There_are_no_tasks_to#</li>
</if><else>
<if @admin_p@ eq 1>
	<a href="admin/index">#evaluation.Evaluations_Admin#</a>
	<br>
	<br>
</if>
 <multiple name="grades">
	<if @simple_p@ eq 0>
	<li><strong>@grades.grade_plural_name;noquote@</strong> <br>
	</if>
	<include src="/packages/evaluation/lib/evaluations-chunk" grade_item_id=@grades.grade_item_id@ grade_id=@grades.grade_id@ evaluations_orderby=@evaluations_orderby@>
        <br><br>
	</li>
 </multiple>
 <if @admin_p@ eq "0">
 <br>#evaluation.lt_Your_total_grade_in_t# <strong>@total_class_grade@/@max_possible_grade@ </strong>
 </if>
</else>
</ul>
