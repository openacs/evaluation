<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>

<p>#evaluation.lt_Distribution_for_grad#
<if @grade_comments@ not nil>
<p>@grade_comments@
</if>

<if @grades:rowcount@ gt 0>
   <form action="distribution-edit-2">
      <input type=hidden name=grade_id value="@grade_id@">
		<blockquote>
		<listtemplate name="grades"></listtemplate>
	    </blockquote>
        <input type=submit value=Submit>
    </form>
</if><else>
<p>#evaluation.lt_There_are_no_tasks_as#
</else>
</p>
