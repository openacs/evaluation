<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<h2>Confirm your evaluation(s) on "@task_name@"</h2>

<if @evaluations_gs:rowcount@ gt 0>
   <form enctype="multipart/form-data" action="evaluate-students-2" method="post">
	@export_vars;noquote@
		<blockquote>
        <table>
          <multiple name="evaluations_gs">
                <if @evaluations_gs.rownum@ odd><table bgcolor="#EAF2FF"></if><else><table bgcolor="white"></else>
						<tr><th align="right">Name:</th><td>@evaluations_gs.party_name@</td></tr>
					 	<tr><th align="right">Grade:</th><td>@evaluations_gs.grade@ / @max_grade@</td></tr>
                     	<tr><th align="right">Comments/Edit reason:</th><td>@evaluations_gs.comment@</td></tr>
                     	<tr><th align="right">Will the studen(s) be <br /> able to see the grade?</th><td>@evaluations_gs.show_student@</td></tr>
                    </tr>
					</table>
          </multiple>
        </table>
		</blockquote>
        <input type=submit value="Grade Students">
    </form>
</if><else>
There are no grades in the csv file or there are no modifications in the csv file.
</else>