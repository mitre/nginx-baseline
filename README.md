DevSec Nginx Baseline
=====================

This Compliance Profile ensures, that all hardening projects keep the same quality.

- https://github.com/dev-sec/ansible-nginx-hardening
- https://github.com/dev-sec/chef-nginx-hardening
- https://github.com/dev-sec/puppet-nginx-hardening

## Standalone Usage

This Compliance Profile requires [InSpec](https://github.com/chef/inspec) for execution:

```
$ git clone https://github.com/mitre/nginx-baseline
$ inspec exec nginx-baseline
```

You can also execute the profile directly from Github:

```
$ inspec exec https://github.com/mitre/nginx-baseline
```

## License and Author

* Author:: Patrick Muench <patrick.muench1111@googlemail.com>
* Author:: Dominik Richter <dominik.richter@googlemail.com>
* Author:: Christoph Hartmann <chris@lollyrock.com>
* Author:: Rony Xaiver
* Author:: Aaron Lippold <lippold@gmail.com>

* Copyright 2014-2016, The Hardening Framework Team

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## NOTICE 

© 2018 The MITRE Corporation.

Approved for Public Release; Distribution Unlimited. Case Number 18-3678.  

## NOTICE
MITRE hereby grants express written permission to use, reproduce, distribute, modify, and otherwise leverage this software to the extent permitted by the licensed terms provided in the LICENSE.md file included with this project.

## NOTICE

This software was produced for the U. S. Government under Contract Number HHSM-500-2012-00008I, and is subject to Federal Acquisition Regulation Clause 52.227-14, Rights in Data-General.  

No other use other than that granted to the U. S. Government, or to those acting on behalf of the U. S. Government under that Clause is authorized without the express written permission of The MITRE Corporation. 

For further information, please contact The MITRE Corporation, Contracts Management Office, 7515 Colshire Drive, McLean, VA  22102-7539, (703) 983-6000.
