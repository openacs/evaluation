<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<h2>#evaluation.lt_Audit_info_for_task_t#</h2>

<if @parties:rowcount@ gt 0>
<ul>
<multiple name="parties">
 		<li><strong>@parties.party_name@</strong>
		<include src="../../../lib/audit-chunk" task_id=@task_id@ party_id=@parties.party_id@>
		</li>
</multiple>
</ul>
</if><else>
There is no audit info for this task because there are no students evaluated.
</else>



