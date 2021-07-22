# nginx-baseline

InSpec Profile to validate the secure configuration of nginx-baseline, against [DISA's](https://iase.disa.mil/stigs/Pages/index.aspx) NGINX STIG

## Getting Started  
It is intended and recommended that InSpec run this profile from a __"runner"__ host (such as a DevOps orchestration server, an administrative management system, or a developer's workstation/laptop) against the target remotely over __ssh__.

The latest versions and installation options are available at the [InSpec](http://inspec.io/) site.

## Tailoring to Your Environment
The following inputs must be configured in an inputs ".yml" file for the profile to run correctly for your specific environment. More information about InSpec inputs can be found in the [InSpec Profile Documentation](https://www.inspec.io/docs/reference/profiles/).

```yaml
# Path for the nginx configuration file
nginx_conf_file: ''

# Path to nginx backup repository
nginx_backup_repository: ''

# Subnet of the DMZ
dmz_subnet: ''

# Minimum Web vendor-supported version.
nginx_min_ver: ''

# Nginx owner
nginx_owner: ''

# The Nginx group
nginx_group: ''

# The system adminstrator
sys_admin: []

# The system adminstrator group
sys_admin_group: ''

# List of non admin user accounts
authorized_user_list: []

# Monitoring software for CGI or equivalent programs
monitoring_software: []

# List of disallowed packages
disallowed_packages_list: []

# disallowed_compiler_list
disallowed_compiler_list: []

# DoD-approved PKIs (e.g., DoD PKI, DoD ECA, and DoD-approved external partners
dod_approved_pkis: []

# File list of  documentation, sample code, example applications, and tutorials
nginx_disallowed_file_list: []

# File list of allowed documentation, sample code, example applications, and tutorials
nginx_allowed_file_list: []

# List of  authorized nginx modules
nginx_authorized_modules: []

# List of unauthorized nginx modules
nginx_unauthorized_modules: []

# Path for the nginx binary
nginx_path: ''

# domain and port to the OCSP Server
ocsp_server: ''

# crl_udpate_frequency
crl_udpate_frequency: 7
```

# Running This Baseline Directly from Github

```
# How to run
inspec exec https://github.com/mitre/nginx-baseline/archive/master.tar.gz -t ssh:// --input-file=<path_to_your_inputs_file/name_of_your_inputs_file.yml> --reporter=cli json:<path_to_your_output_file/name_of_your_output_file.json>
```

### Different Run Options

  [Full exec options](https://docs.chef.io/inspec/cli/#options-3)

## Running This Baseline from a local Archive copy 

If your runner is not always expected to have direct access to GitHub, use the following steps to create an archive bundle of this baseline and all of its dependent tests:

(Git is required to clone the InSpec profile using the instructions below. Git can be downloaded from the [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) site.)

When the __"runner"__ host uses this profile baseline for the first time, follow these steps: 

```
mkdir profiles
cd profiles
git clone https://github.com/mitre/nginx-baseline
inspec archive nginx-baseline
inspec exec <name of generated archive> -t ssh:// --input-file=<path_to_your_inputs_file/name_of_your_inputs_file.yml> --reporter=cli json:<path_to_your_output_file/name_of_your_output_file.json>
```
For every successive run, follow these steps to always have the latest version of this baseline:

```
cd nginx-baseline
git pull
cd ..
inspec archive nginx-baseline --overwrite
inspec exec <name of generated archive> -t ssh:// --input-file=<path_to_your_inputs_file/name_of_your_inputs_file.yml> --reporter=cli json:<path_to_your_output_file/name_of_your_output_file.json>
```

## Viewing the JSON Results

The JSON results output file can be loaded into __[heimdall-lite](https://heimdall-lite.mitre.org/)__ for a user-interactive, graphical view of the InSpec results. 

The JSON InSpec results file may also be loaded into a __[full heimdall server](https://github.com/mitre/heimdall)__, allowing for additional functionality such as to store and compare multiple profile runs.

## Authors
* Patrick Muench <patrick.muench1111@googlemail.com>
* Dominik Richter <dominik.richter@googlemail.com>
* Christoph Hartmann <chris@lollyrock.com>
* Rony Xavier - [rx294](https://github.com/rx294)
* Aaron Lippold <lippold@gmail.com>

## Special Thanks 
* Mohamed El-Sharkawi - [HackerShark](https://github.com/HackerShark)
* Shivani Karikar - [karikarshivani](https://github.com/karikarshivani)

## NOTICE 

© 2018-2020 The MITRE Corporation.

Approved for Public Release; Distribution Unlimited. Case Number 18-3678.

## NOTICE

MITRE hereby grants express written permission to use, reproduce, distribute, modify, and otherwise leverage this software to the extent permitted by the licensed terms provided in the LICENSE.md file included with this project.

## NOTICE

This software was produced for the U. S. Government under Contract Number HHSM-500-2012-00008I, and is subject to Federal Acquisition Regulation Clause 52.227-14, Rights in Data-General.  

No other use other than that granted to the U. S. Government, or to those acting on behalf of the U. S. Government under that Clause is authorized without the express written permission of The MITRE Corporation. 

For further information, please contact The MITRE Corporation, Contracts Management Office, 7515 Colshire Drive, McLean, VA  22102-7539, (703) 983-6000.

## NOTICE  

DISA STIGs are published by DISA IASE, see: https://iase.disa.mil/Pages/privacy_policy.aspx