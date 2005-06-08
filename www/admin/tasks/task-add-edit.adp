<master>
  <property name="title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>
<script langauge="javascript">
	var browserType;

	if (document.layers) {browserType = "nn4"}
	if (document.all) {browserType = "ie"}
	if (window.navigator.userAgent.toLowerCase().match("gecko")) {browserType= "gecko"}

	function TaskInGroups() {
        	if (document.forms['task'].number_of_members.value > 1)
		{
		 if (browserType == "gecko" )
		   document.poppedLayer = eval('document.getElementById(\'silentDiv\')');
		 else if (browserType == "ie")
	           document.poppedLayer = eval('document.all[\'silentDiv\']');
		 else
	   	   document.poppedLayer = eval('document.layers[\'`silentDiv\']');
	  	 document.poppedLayer.style.visibility = "visible";
		}

        	if (document.forms['task'].number_of_members.value == 1)
		{
		 if (browserType == "gecko" )
		   document.poppedLayer = eval('document.getElementById(\'silentDiv\')');
		 else if (browserType == "ie")
	           document.poppedLayer = eval('document.all[\'silentDiv\']');
		 else
	   	   document.poppedLayer = eval('document.layers[\'`silentDiv\']');
	  	 document.poppedLayer.style.visibility = "hidden";
		}

    	}
</script>

<if @new_p@ eq 1 and @community_id@ not nil>
  <p align="right">
  </p>
</if>
<p><formtemplate id="task"></formtemplate></p>

