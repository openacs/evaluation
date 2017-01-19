<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>
<if @simple_p;literal@ false>
<if @admin_p;literal@ true>
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
	<include src="/packages/evaluation/lib/tasks-chunk" grade_item_id="@grades.grade_item_id;literal@" grade_id="@grades.grade_id;literal@" assignments_orderby="@assignments_orderby;literal@">
        <br><br>
	</li>
</multiple>
</else>
</ul>
<br>
</if>
<if @simple_p;literal@ false>
<h2>#evaluation.Evaluations#</h2>
</if>
<else>
<h1 class="blue">#evaluation.Evaluations_gradebook#</h1>
</else>
<ul>
<if @grades:rowcount@ eq 0>
<li>#evaluation.lt_There_are_no_tasks_to#</li>
</if><else>
<if @admin_p;literal@ true>
	<a href="admin/index">#evaluation.Evaluations_Admin#</a>
	<br>
	<br>
</if>
 <multiple name="grades">
	<if @simple_p;literal@ false>
	<li><strong>@grades.grade_plural_name;noquote@</strong> <br>
	</if>
	<include src="/packages/evaluation/lib/evaluations-chunk" grade_item_id="@grades.grade_item_id;literal@" grade_id="@grades.grade_id;literal@" evaluations_orderby="@evaluations_orderby;literal@">
        <br><br>
	</li>
 </multiple>
 <if @admin_p;literal@ false>
 <br>#evaluation.lt_Your_total_grade_in_t# <strong>@total_class_grade@/@max_possible_grade@ </strong>
 </if>
</else>
</ul>
