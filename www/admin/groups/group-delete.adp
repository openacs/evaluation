<master>
<property name="context">@context;noquote@</property>
<property name="title">@page_title@</property>

Are you sure you want to remove the group "@group_name@"? (If the group has an evaluation/answer associated, it will be deleted too)

<p>

<center>
<include src="../../../lib/confirm-delete-form" action="group-delete-2" export_vars="@export_vars;noquote@" no_button="No, I want to cancel my request" yes_button="Yes, I really want to remove this group">
</center>

</p>