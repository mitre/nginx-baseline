# encoding: utf-8
#
=begin
-----------------
Benchmark: APACHE SERVER 2.2 for Unix
Status: Accepted

All directives specified in this STIG must be specifically set (i.e. the
server is not allowed to revert to programmed defaults for these directives).
Included files should be reviewed if they are used. Procedures for reviewing
included files are included in the overview document. The use of .htaccess
files are not authorized for use according to the STIG. However, if they are
used, there are procedures for reviewing them in the overview document. The
Web Policy STIG should be used in addition to the Apache Site and Server STIGs
in order to do a comprehensive web server review.

Release Date: 2015-08-28
Version: 1
Publisher: DISA
Source: STIG.DOD.MIL
uri: http://iase.disa.mil
-----------------
=end

only_if do
  package('nginx').installed? || command('nginx').exist?
end

control "V-13621" do

  title "All web server documentation, sample code, example applications, and
  tutorials must be removed from a production web server."

  desc "Web server documentation, sample code, example applications, and
  tutorials may be an exploitable threat to a web server. A production web
  server may only contain components that are operationally necessary (e.g.,
  compiled code, scripts, web-content, etc.). Delete all directories that
  contain samples and any scripts used to execute the samples. If there is a
  requirement to maintain these directories at the site on non-production
  servers for training purposes, have permissions set to only allow access to
  authorized users (i.e., web administrators and systems administrators).
  Sample applications or scripts have not been evaluated and approved for use
  and may introduce vulnerabilities to the system."

  impact 0.7
  tag "severity": "high"
  tag "gtitle": "WG385"
  tag "gid": "V-13621"
  tag "rid": "SV-32933r1_rule"
  tag "stig_id": "WG385 A22"
  tag "nist": ["CM-6", "Rev_4"]

  tag "check": "Query the SA to determine if all directories that contain
  samples and any scripts used to execute the samples have been removed from
  the server. Each web server has its own list of sample files. This may
  change with the software versions, but the following are some examples of
  what to look for (This should not be the definitive list of sample files,
  but only an example of the common samples that are provided with the
  associated web server. This list will be updated as additional information
  is discovered.):

  ls -Ll /usr/share/man/man8/nginx.8.gz

  If there is a requirement to maintain these directories at the site for
  training or other such purposes, have permissions or set the permissions to
  only allow access to authorized users. If any sample files are found on the
  web server, this is a finding."

  nginx_disallowed_file_list = input('nginx_disallowed_file_list')

  nginx_exception_files = input('nginx_allowed_file_list')

  nginx_owner = input('nginx_owner')

  sys_admin = input('sys_admin')

  nginx_group = input('nginx_group')

  sys_admin_group = input('sys_admin_group')

  begin

    authorized_sa_user_list = sys_admin.clone << nginx_owner
    authorized_sa_group_list = sys_admin_group.clone << nginx_group

    nginx_disallowed_file_list.each do |file|
      describe file(file) do
        it { should_not exist }
      end
    end

    nginx_exception_files.each do |file|
      describe file(file) do
        its('owner') { should be_in authorized_sa_user_list }
        its('group') { should be_in authorized_sa_group_list }
        it { should_not be_executable }
        it { should_not be_writable.by('group') }
        it { should_not be_readable.by('others') }
        it { should_not be_writable.by('others') }
      end
    end
  rescue Exception => msg
    describe "Exception: #{msg}" do
      it { should be_nil }
    end
  end
end
