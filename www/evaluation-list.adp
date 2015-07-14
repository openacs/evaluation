<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>


<ul>
<multiple name="grades">
	<li><strong>@grades.grade_plural_name@</strong> <br>
	<include src="/packages/evaluation/lib/evaluations-chunk" grade_id="@grades.grade_id;literal@">
	</li>
</multiple>
</ul>
@actions;noquote@
