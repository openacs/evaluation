<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<h2>#evaluation.lt_Grades_report_of_stud#</h2><br />

<table>
<tr>
 <td>@portrait;noquote@ </td>
 <td>#evaluation.Name_student_name#<br>#evaluation.Email# <a href="mailto:@email@">@email@</a></td>
</tr>
</table>
<br />
<ul>
<if @grades:rowcount@ eq 0>
<li>#evaluation.lt_There_is_no_info_for_#</li>
</if><else>
<multiple name="grades">
	<li><strong>@grades.grade_plural_name@</strong> <br />
	<include src="../../../lib/student-grades-report-chunk" grade_id=@grades.grade_id@ orderby=@orderby@ student_id=@student_id@>
	</li>
</multiple>
<h2>#evaluation.lt_TOTAL_GRADE_total_cla# / @max_possible_grade@ </h2>
</else>
</ul>




