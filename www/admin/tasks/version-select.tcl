ad_page_contract {
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    
} {
    {return_url:localurl ""}
}

set portal_id [dotlrn_community::get_portal_id -community_id [dotlrn_community::get_community_id]]
set package_id [ad_conn package_id]
set version  [parameter::get -parameter "SimpleVersion"]
set options [list [list [_ evaluation-portlet.simple_version] 1] [list [_ evaluation-portlet.full_version] 0]]

ad_form -name set_version -form {
    {version:text(select) 
	{label "\#evaluation-portlet.version_label\#" }
	{value $version}
	{options $options}
    }
    {return_url:text(hidden)
	{value $return_url}
    }

} -on_submit {
    parameter::set_value -parameter "SimpleVersion" -value $version 
    if { $version == 1} {
	evaluation_assignments_portlet::remove_self_from_page -portal_id $portal_id -package_id $package_id
    } else {
	evaluation_assignments_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id -param_action "append" -page_name \#evaluation.evaluationpagename\# -force_region 1
    }
} -after_submit {
    ad_returnredirect $return_url
}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
