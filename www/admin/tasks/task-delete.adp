<master>
<property name="context">@context;noquote@</property>
<property name="title">Remove Grade</property>

Are you sure you want to delete the task "@task_name@"? (it has @task_sols@ solution(s)  and @task_answers@ answer(s) assoticiated and they will be deleted too)

<p>

<center>
<include src="../../../lib/confirm-delete-form" action="task-delete-2" export_vars="@export_vars;noquote@" no_button="No, I want to cancel my request" yes_button="Yes, I really want to remove this task">
</center>

