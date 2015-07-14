<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<h2>#evaluation.lt_Grades_report_of_stud#</h2><br>

<table>
<tr>
 <td>@portrait;noquote@ </td>
 <td>#evaluation.Name_student_name#<br>#evaluation.Email# <a href="mailto:@email@">@email@</a></td>
</tr>
</table>
<br>
<if @grades:rowcount@ eq 0>
<p>#evaluation.lt_There_is_no_info_for_#</p>
</if>
<else>
<ul>
<multiple name="grades">
	<li><strong>@grades.grade_plural_name@</strong> <br>
	<include src="/packages/evaluation/lib/student-grades-report-chunk" grade_id="@grades.grade_id;literal@" orderby="@orderby;literal@" student_id="@student_id;literal@">
	</li>
</multiple>
</ul>
<h2>#evaluation.lt_TOTAL_GRADE_total_cla# / @max_possible_grade@ </h2>
</else>
