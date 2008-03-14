<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<ul>
<multiple name="grades">
	<li><strong>@grades.grade_plural_name@</strong> <br>
	<include src="/packages/evaluation/lib/evaluations-chunk" grade_id=@grades.grade_id@>
	</li>
</multiple>
</ul>
@actions;noquote@
