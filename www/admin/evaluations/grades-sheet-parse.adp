<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<h2>#evaluation.lt_Confirm_your_evaluati#</h2>

<if @evaluations_gs:rowcount@ gt 0>
   <form enctype="multipart/form-data" action="evaluate-students-2" method="post">
	@export_vars;noquote@

        <table>
          <multiple name="evaluations_gs">
                <if @evaluations_gs.rownum@ odd><table bgcolor="#EAF2FF"></if><else><table bgcolor="white"></else>
						<tr><th align="right">#evaluation.Name#</th><td>@evaluations_gs.party_name@</td></tr>
					 	<tr><th align="right">#evaluation.Grade#</th><td>@evaluations_gs.grade@ / @max_grade@</td></tr>
                     	<tr><th align="right">#evaluation.CommentsEdit_reason#</th><td>@evaluations_gs.comment@</td></tr>
                     	<tr><th align="right">#evaluation.Will_the_studens_be#<br> #evaluation.lt_able_to_see_the_grade#</th><td>@evaluations_gs.show_student@</td></tr>
                    </tr>
					</table>
          </multiple>
        </table>
        <div>
        <input type="submit" value="#evaluation.Grade_1#"> <input type="button" value="#evaluation.Go_Back#" onClick="history.go(-1)">
        </div>
    </form>
</if><else>
#evaluation.lt_There_is_no_info_#
</else>
