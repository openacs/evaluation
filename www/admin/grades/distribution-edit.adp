<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>
<link rel="stylesheet" type="text/css" media="all" href="/resources/evaluation/evaluation.css" />
<if @simple_p@ eq 1>
<h1 class="blue">#evaluation.lt_Distribution_for_grad#</h1>
<br>
<br>
<div id="evaluations">
<table class="title" width=100%>
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="40">
  <tr>
    <td valign="middle" width="30%" style="padding-left: 10px;"><text class="blue"><b>@grade_plural_name_up@</b> (@grade_weight@% #evaluation-portlet.total_grade#)</text></td>
  </tr>
</table>
</div>
</if>
<else>
<p>#evaluation.lt_Distribution_for_grad#
<if @grade_comments@ not nil>
<p>@grade_comments@
</if>
</else>
<br>
<if @grade_weight@ gt 0>
<if @grades:rowcount@ gt 0>
<if @simple_p@ eq 0>
<p> #evaluation.lt_grade_plural_name_rep_1# </p>
</if>
   <form action="distribution-edit-2">
      <input type=hidden name=grade_id value="@grade_id@">
		<blockquote>
		<listtemplate name="grades"></listtemplate>
	    </blockquote>

<table align="left">
<tr>
<if @simple_p@ eq 1><td align= "left"><input type="image" src="/resources/evaluation/submit.gif" name=info></td></if><else><td align=left><input type=submit value=Submit></td></else>
      </form>

    </form>
      <form action="distribution-edit-3">
      <input type=hidden name=grade_id value="@grade_id@">
<td align= "left">
	<if @simple_p@ eq 1>
	       <input type="image" src="/resources/evaluation/default.gif">
	</if>
	<else>
	<input type=submit value="Set To Default">
        </else>
</td>
      </form>

</tr>
</table>
</if><else>
<p>#evaluation.lt_There_are_no_tasks_as#</p>
</else>
</p>
</if>
<else>
<center>
 #evaluation.grade_weight_zero#
</center>
</else>
<br>
<if @simple_p@ eq 1>
<table align= left class=title>
<tr>
<td>
<include src=instructions>
</td>
<td>
</td>
</tr>
</table>
</if>
