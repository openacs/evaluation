<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>

<h2>#evaluation.lt_Audit_info_for_task_t#</h2>

<if @parties:rowcount@ gt 0>
<ul>
<multiple name="parties">
 		<li><strong>@parties.party_name@</strong>
		<include src="/packages/evaluation/lib/audit-chunk" task_item_id="@task_item_id;literal@" task_id="@task_id;literal@" party_id="@parties.party_id;literal@" orderby="@orderby;literal@">
		</li>
</multiple>
</ul>
</if><else>
#evaluation.lt_There_is_no_audit_inf#
</else>




