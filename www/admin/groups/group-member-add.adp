<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @evaluation_groups:rowcount@ gt 0>
<h3>Please select the group</h3>
<blockquote>
<listtemplate name="evaluation_groups"></listtemplate>
</blockquote>
</form>
</if>


