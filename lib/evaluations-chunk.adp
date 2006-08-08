<link rel="stylesheet" type="text/css" media="all" href="/resources/evaluation/evaluation.css" />
<if @simple_p@ eq 1>
<div id="evaluations">
<table class="title" width=100%>
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="40">
  <tr>
    <td valign="middle" width="30%" style="padding-left: 10px;"><text class="blue"><b>@grade_plural_name@</b> (@grade_weight@% #evaluation-portlet.total_grade#)</text>
    <td valign="middle" width="67%" align="right" style="font-size: 10px; color: #354785; font-weight: bold;">  
@actions;noquote@
    </td>
  </tr>
</table>
</div>
</if>
<br>
<listtemplate name="grade_tasks"></listtemplate>
<if @simple_p@ eq 0>
 <if @admin_p@ eq 1>
   #evaluation.lt_Weight_used_in_grade_#
 </if>
 <else>
 #evaluation-portlet.lt_smallTotal_points_in_#
 </else>
</if>


