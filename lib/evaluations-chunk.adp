<if @simple_p;literal@ true>
<div id="evaluations">
<table class="title" width="100%">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="40">
  <tr>
    <td valign="middle" width="30%" style="padding-left: 10px;">
              <strong>@grade_plural_name@</strong> (@grade_weight@% #evaluation-portlet.total_grade#)
    <td valign="middle" width="67%" align="right" style="font-size: 10px; color: #354785; font-weight: bold;">  
@actions;noquote@
    </td>
  </tr>
</table>
</div>
</if>

<listtemplate name="@list_name;noquote@"></listtemplate>

<if @simple_p;literal@ false>
 <if @admin_p;literal@ true>
   <p>#evaluation.lt_Weight_used_in_grade_#</p>
 </if>
 <else>
   <p>#evaluation-portlet.lt_smallTotal_points_in_#</p>
 </else>
</if>


