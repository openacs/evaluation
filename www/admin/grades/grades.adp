<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<if @simple_p;literal@ true>
<h1 class="blue">@page_title;noquote@</h1>
<br>
<div id="evaluations">
<table class="title" width="100%">
<table width="100%" style="border:0px" alt="" cellpadding="0" cellspacing="0" height="40">
  <tr>
    <td valign="middle" width="30%" style="padding-left: 10px;"><text class="blue"><strong>ALL ASIGNMENT TYPES</strong></text></td>

    <td align="right" valign="middle" width="67%" align="right" style="font-size: 10px; color: #354785; font-weight: bold;">  
	@actions;noquote@
    </td>
  </tr>
</table>
</div>
</if>

<listtemplate name="grades"></listtemplate>
<p>@notice;noquote@</p>

