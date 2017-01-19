  <master>

    <property name="doc(title)">@page_title;literal@</property>
    <property name="context">@context;literal@</property>

    <if @admin_p;literal@ true>
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
        <include src="/packages/evaluation/lib/tasks-chunk" grade_item_id="@grades.grade_item_id;literal@" grade_id="@grades.grade_id;literal@" assignments_orderby="@assignments_orderby;literal@">
      </multiple>
    </else>

    <h1>#evaluation.Evaluations#</h1>

    <if @grades:rowcount@ eq 0>
      <p>#evaluation.lt_There_are_no_tasks_to#</p>
    </if>
    <else>
      <multiple name="grades">
        <h2>@grades.grade_plural_name;noquote@</h2>
        <include src="/packages/evaluation/lib/evaluations-chunk" grade_item_id="@grades.grade_item_id;literal@" grade_id="@grades.grade_id;literal@" evaluations_orderby="@evaluations_orderby;literal@">
      </multiple>
      <if @admin_p;literal@ false>
        <p>
          #evaluation.lt_Your_total_grade_in_t# 
          <strong>@total_class_grade@/@max_possible_grade@ </strong>
        </p>
      </if>
    </else>

