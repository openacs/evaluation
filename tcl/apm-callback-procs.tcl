# /packages/evaluation/tcl/apm-callback-procs.tcl

ad_library {

    Evaluations Package APM callbacks library
    
    Procedures that deal with installing, instantiating, mounting.

    @creation-date Apr 2004
    @author jopez@galileo.edu
    @cvs-id $Id$
}

namespace eval evaluation {}
namespace eval evaluation::apm {}


ad_proc -private evaluation::apm::package_install {  
} { 
    Does the integration whith the notifications package.  
} { 
    db_transaction { 
	
	# Create the impl and aliases for one assignment
	set impl_id [create_one_assignment_impl]
	
	# Create the notification type for one assignment
	set type_id [create_one_assignment_type -impl_id $impl_id]
	
	# Enable the delivery intervals and delivery methods for a specific assignment
	enable_intervals_and_methods -type_id $type_id

	# Create the impl and aliases for one evaluation
	set impl_id [create_one_evaluation_impl]
	
	# Create the notification type for one evaluation
	set type_id [create_one_evaluation_type -impl_id $impl_id]
	
	# Enable the delivery intervals and delivery methods for a specific evaluation
	enable_intervals_and_methods -type_id $type_id
	
    }
}

ad_proc -private evaluation::apm::package_uninstall { 
} {

    Cleans the integration whith the notifications package.  

} {

    db_transaction {
	
        # Delete the type_id for a specific assignment
        notification::type::delete -short_name one_assignment_notif
	
        # Delete the implementation for the notification of an assignment
        delete_assignment_impl
	
        # Delete the type_id for a especific evaluation
        notification::type::delete -short_name one_evaluation_notif
	
        # Delete the implementation for the notification of an evaluation
	delete_evaluation_impl
	
    }
}

ad_proc -private evaluation::apm::package_instantiate { 
    -package_id:required
} {

    Define Evaluation folders

} {

    set creation_user [ad_verify_and_get_user_id]
    set creation_ip [ad_conn peeraddr]
    
    create_folders -package_id $package_id
}


ad_proc -private evaluation::apm::package_uninstantiate { 
    -package_id:required
} {

    Delete Evaluation stuff

} {
    
    delete_contents -package_id $package_id

}
