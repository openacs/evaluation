<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>

<h2>Audit info for task "@task_name@"</h2>

<ul>
<multiple name="parties">
 		<li><strong>@parties.party_name@</strong>
		<include src="../../../lib/audit-chunk" task_id=@task_id@ party_id=@parties.party_id@>
		</li>
</multiple>
</ul>



