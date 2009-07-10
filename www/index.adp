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
    <ul>
      <if @grades:rowcount@ eq 0>
        <li>#evaluation.lt_There_are_no_tasks_fo#</li>
      </if>
      <else>
        <multiple name="grades">
          <li>
            <strong>@grades.grade_plural_name;noquote@</strong>
            <include src="/packages/evaluation/lib/tasks-chunk" grade_item_id=@grades.grade_item_id@ grade_id=@grades.grade_id@ assignments_orderby=@assignments_orderby@>
          </li>
        </multiple>
      </else>
    </ul>

    <h2>#evaluation.Evaluations#</h2>
    <ul>
      <if @grades:rowcount@ eq 0>
        <li>#evaluation.lt_There_are_no_tasks_to#</li>
      </if>
      <else>
        <multiple name="grades">
          <li>
            <strong>@grades.grade_plural_name;noquote@</strong>
            <include src="/packages/evaluation/lib/evaluations-chunk" grade_item_id=@grades.grade_item_id@ grade_id=@grades.grade_id@ evaluations_orderby=@evaluations_orderby@>
          </li>
        </multiple>
        <if @admin_p@ eq "0">
          #evaluation.lt_Your_total_grade_in_t# 
          <strong>@total_class_grade@/@max_possible_grade@ </strong>
        </if>
      </else>
    </ul>
