<master>
  <property name="doc(title)">@page_title;literal@</property>
  <property name="context">@context;literal@</property>

<script type="text/javascript"<if @::__csp_nonce@ not nil> nonce="@::__csp_nonce;literal@"</if>>
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

<if @more_communities_option@ eq 1>
  <p align="right">
    #evaluation.lt_To_add_this_assignmen#  <br> #evaluation.lt_please_check_the_last#
  </p>
</if>
<formtemplate id="task"></formtemplate>

