<master>
<property name="context">@context;noquote@</property>
<property name="title">Remove Grade</property>

Are you sure you want to remove the assignment type "@grade_plural_name@"? (If your answer is yes, all the evaluations, tasks, tasks solutions and answers associated with this assignment type will be deleted too)

<p>

<center>
<include src="../../../lib/confirm-delete-form" action="grades-delete-2" export_vars="@export_vars;noquote@" no_button="No, I want to cancel my request" yes_button="Yes, I really want to remove this grade">
</center>

