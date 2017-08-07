<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<if @simple_p;literal@ true>
<h1 class="blue">#evaluation.lt_Distribution_for_grad#</h1>
<br>
<br>
<div id="evaluations">
<table class="title" width="100%">
<table width="100%" style="border:0px" alt="" cellpadding="0" cellspacing="0" height="40">
  <tr>
    <td valign="middle" width="30%" style="padding-left: 10px;"><text class="blue"><strong>@grade_plural_name_up@</strong> (@grade_weight@% #evaluation-portlet.total_grade#)</text></td>
  </tr>
</table>
</div>
</if>
<else>
<p>#evaluation.lt_Distribution_for_grad#</p>
<if @grade_comments@ not nil>
<p>@grade_comments@</p>
</if>
</else>
<if @grade_weight@ gt 0>
<if @grades:rowcount@ gt 0>
<if @simple_p;literal@ false>
<p> #evaluation.lt_grade_plural_name_rep_1# </p>
</if>
   <form action="distribution-edit-2">
	  <listtemplate name="grades"></listtemplate>
      <div><input type="hidden" name="grade_id" value="@grade_id@"></div>
      <div>
      <if @simple_p;literal@ true><input type="image" src="/resources/evaluation/submit.gif" name="info"></if>
	  <else><input type="submit" value="Submit"></else>
      </div>
   </form>
   <form action="distribution-edit-3" style="display:inline;">
      <div><input type="hidden" name="grade_id" value="@grade_id@"></div>
      <div>
	    <if @simple_p;literal@ true><input type="image" src="/resources/evaluation/default.gif"></if>
	    <else><input type="submit" value="Set To Default"></else>
      </div>
    </form>
</if><else>
<p>#evaluation.lt_There_are_no_tasks_as#</p>
</else>
</if>
<else>
<div style="text-align:center">
 #evaluation.grade_weight_zero#
</div>
</else>
<br>
<br>
<if @simple_p;literal@ true>
<include src=instructions>

</if>
