-- 
-- 
-- 
-- @author Victor Guerra (guerra@galileo.edu)
-- @creation-date 2007-12-10
-- @arch-tag: f358e2fa-fa9c-4d3a-8783-c897efb7643d
-- @cvs-id $Id$
--


update apm_parameters set default_value = 'zip' where parameter_name = 'ArchiveExtension' and package_key = 'evaluation';
update apm_parameters set default_value = '/usr/bin/zip -r {out_file} {in_file}' where parameter_name = 'ArchiveCommand' and package_key = 'evaluation';
update apm_parameter_values set attr_value = '/usr/bin/zip -r {out_file} {in_file}' where parameter_id = (select parameter_id from apm_parameters where parameter_name = 'ArchiveExtension' and package_key = 'evaluation');
update apm_parameter_values set attr_value = 'zip' where parameter_id = (select parameter_id from apm_parameters where parameter_name = 'ArchiveCommand' and package_key = 'evaluation');