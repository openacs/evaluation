<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<h2>#evaluation.lt_Confirm_your_evaluati#</h2>

<if @evaluations_wa:rowcount@ gt 0>
   <form action="evaluate-students-2" method="post">
	@export_vars;noquote@
      <input type=hidden name=task_id value="@task_id@">
      <input type=hidden name=max_grade value="@max_grade@">
		<blockquote>
        <table>
          <multiple name="evaluations_wa">
                <if @evaluations_wa.rownum@ odd><table bgcolor="#EAF2FF"></if><else><table bgcolor="white"></else>
						<tr><th align="right">#evaluation.Name#</th><td>@evaluations_wa.party_name@</td></tr>
					 	<tr><th align="right">#evaluation.Grade#</th><td>@evaluations_wa.grade@ / @max_grade@</td></tr>
                     	<tr><th align="right">#evaluation.Comments#</th><td>@evaluations_wa.comment@</td></tr>
                     	<tr><th align="right">#evaluation.Will_the_studens_be# <br /> #evaluation.lt_able_to_see_the_grade#</th><td>@evaluations_wa.show_student@</td></tr>
                    </tr>
					</table>
          </multiple>
        </table>
		</blockquote>
        <input type=submit value="#evaluation.Grade_1#" > <input type=button value="#evaluation.Go#" onClick="history.go(-1)"> 
   </form> 
</if> 
<if %evaluations_na:rowcount% gt 0> 
  <form action="evaluate-students-2" method="post"> 
  @export_vars;noquote@ 
  <input type=hidden name=task_id value="%task_id%"> 
  <input type=hidden name=max_grade value="%max_grade%"> 
  <blockquote> 
    <table> 
	<multiple name="evaluations_na"> 
	<if %evaluations_na.rownum% odd> <table bgcolor="#EAF2FF"> </if> 
	<else><table bgcolor="white"></else> 
	 <tr><th align="right">#evaluation.Name#</th><td>%evaluations_na.party_name%</td></tr>
	 <tr><th align="right">#evaluation.Grade#</th><td>%evaluations_na.grade% / %max_grade%</td></tr>
	 <tr><th align="right">#evaluation.Comments#</th><td>%evaluations_na.comment%</td></tr>
	 <tr><th align="right">#evaluation.Will_the_studens_be# <br /> #evaluation.lt_able_to_see_the_grade#</th><td>%evaluations_na.show_student%</td></tr>
	 </tr> 
        </table> 
       </multiple> 
    </table> 
  </blockquote> 
  <input type=submit value="#evaluation.Grade_1#" >
  <input type=button value="#evaluation.Go#" onClick="history.go(-1)">
  </form>
</if>

<if @evaluations:rowcount@ gt 0>
   <form action="evaluate-students-2" method="post">
	@export_vars;noquote@
      <input type=hidden name=task_id value="@task_id@">
      <input type=hidden name=max_grade value="@max_grade@">
		<blockquote>
        <table>
          <multiple name="evaluations">
                <if @evaluations.rownum@ odd><table bgcolor="#EAF2FF"></if><else><table bgcolor="white"></else>
						<tr><th align="right">#evaluation.Name#</th><td>@evaluations.party_name@</td></tr>
					 	<tr><th align="right">#evaluation.Grade#</th><td>@evaluations.grade@ / @max_grade@</td></tr>
                     	<tr><th align="right">#evaluation.Edit_Reason#</th><td>@evaluations.reason@</td></tr>
                     	<tr><th align="right">#evaluation.Will_the_studens_be# <br /> #evaluation.lt_able_to_see_the_grade#</th><td>@evaluations.show_student@</td></tr>
                    </tr>
					</table>
          </multiple>
        </table>
		</blockquote>
        <input type=submit value="<# Confirm #>">
    </form>
</if>

</p>



