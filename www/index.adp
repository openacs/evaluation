  <master>

    <property name="title">@page_title;noquote@</property>
    <property name="context">@context;noquote@</property>

    <if @admin_p@ eq 1>
      <div style="float:right">
        <a href="admin/index" class="button">#evaluation.Evaluations_Admin#</a>
      </div>
    </if>

    <h1>#evaluation.Assignments#</h1>
    <p>@notification_chunk;noquote@</p>

    <if @grades:rowcount@ eq 0>
      <p>#evaluation.lt_There_are_no_tasks_fo#</p>
    </if>
    <else>
      <multiple name="grades">
        <h2>@grades.grade_plural_name;noquote@</h2>
        <include src="/packages/evaluation/lib/tasks-chunk" grade_item_id=@grades.grade_item_id@ grade_id=@grades.grade_id@ assignments_orderby=@assignments_orderby@>
      </multiple>
    </else>

    <h1>#evaluation.Evaluations#</h1>

    <if @grades:rowcount@ eq 0>
      <p>#evaluation.lt_There_are_no_tasks_to#</p>
    </if>
    <else>
      <multiple name="grades">
        <h2>@grades.grade_plural_name;noquote@</h2>
        <include src="/packages/evaluation/lib/evaluations-chunk" grade_item_id=@grades.grade_item_id@ grade_id=@grades.grade_id@ evaluations_orderby=@evaluations_orderby@>
      </multiple>
      <if @admin_p@ eq "0">
        <p>
          #evaluation.lt_Your_total_grade_in_t# 
          <strong>@total_class_grade@/@max_possible_grade@ </strong>
        </p>
      </if>
    </else>

