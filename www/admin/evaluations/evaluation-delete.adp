<master>
<property name="context">@context;noquote@</property>
<property name="title">@page_title@</property>

Are you sure you want to remove the evaluaiton on "@party_name@"?

<p>

<center>
<include src="../../../lib/confirm-delete-form" action="evaluation-delete-2" export_vars="@export_vars;noquote@" no_button="No, I want to cancel my request" yes_button="Yes, I really want to remove this evaluation">
</center>

</p>