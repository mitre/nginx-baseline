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

control "V-2259" do

  title "Web server system files must conform to minimum file permission
  requirements."

  desc "This check verifies that the key web server system configuration files
  are owned by the SA or the web administrator controlled account. These same
  files that control the configuration of the web server, and thus its
  behavior, must also be accessible by the account that runs the web service.
  If these files are altered by a malicious user, the web server would no
  longer be under the control of its managers and owners; properties in the
  web server configuration could be altered to compromise the entire server
  platform."

  impact 0.5
  tag "severity": "medium"
  tag "gtitle": "WG300"
  tag "gid": "V-2259"
  tag "rid": "SV-32938r1_rule"
  tag "stig_id": "WG300 A22"
  tag "nist": ["AC-3", "AC-6", "Rev_4"]

  tag "check": "Nginx directory and file permissions and ownership should be
  set per the following table.. The installation directories may vary from one
  installation to the next.If used, the WebAmins group should contain only
  accounts of persons authorized to manage the web server configuration,
  otherwise the root group should own all Nginx files and directories.

  If the files and directories are not set to the following permissions or more
  restrictive, this is a finding.

  grep for the ""root"" directive on the nginx.conf file and any separate
  included configuration files to find the Nginx root directory

  /usr/sbin/nginx       root WebAdmin  550/550
  /etc/nginx/           root WebAdmin 770/660
  /etc/nginx/conf.d     root WebAdmin 770/660
  /etc/nginx/modules    root WebAdmin 770/660
  /usr/share/nginx/html root WebAdmin  775/664
  /var/log/nginx        root WebAdmin  750/640

  NOTE:  The permissions are noted as directories / files"

  tag "fix": "Use the chmod command to set permissions on the web server
  system directories and files as follows.

  /usr/sbin/nginx       root WebAdmin  550/550
  /etc/nginx/           root WebAdmin 770/660
  /etc/nginx/conf.d     root WebAdmin 770/660
  /etc/nginx/modules    root WebAdmin 770/660
  /usr/share/nginx/html root WebAdmin  775/664
  /var/log/nginx        root WebAdmin  750/640
  "

  nginx_conf_file = input('nginx_conf_file')

  nginx_owner = input('nginx_owner')

  sys_admin = input('sys_admin')

  nginx_group = input('nginx_group')

  sys_admin_group = input('sys_admin_group')

  # TODO: should we consider the sticky bits on this? see previous commit
  begin
    authorized_sa_user_list = sys_admin.clone << nginx_owner
    authorized_sa_group_list = sys_admin_group.clone << nginx_group

    describe.one do
      describe file('/usr/sbin/nginx') do
        its('owner') { should be_in authorized_sa_user_list }
        its('group') { should be_in authorized_sa_group_list }
        it { should_not be_writable }
        it { should_not be_readable.by('others') }
        it { should_not be_executable.by('others') }
      end
      describe file('/usr/sbin/nginx') do
        it { should be_owned_by nginx_owner }
        its('group') { should cmp nginx_group }
        it { should_not be_writable }
        it { should_not be_readable.by('others') }
        it { should_not be_executable.by('others') }
      end
    end
    describe.one do
      describe file('/etc/nginx/') do
        its('owner') { should be_in authorized_sa_user_list }
        its('group') { should be_in authorized_sa_group_list }
        it { should_not be_readable.by('others') }
        it { should_not be_writable.by('others') }
        it { should_not be_executable.by('others') }
      end
      describe file('/etc/nginx/') do
        it { should be_owned_by nginx_owner }
        its('group') { should cmp nginx_group }
        it { should_not be_executable }
        it { should_not be_readable.by('others') }
        it { should_not be_writable.by('others') }
      end
    end
    describe.one do
      describe file('/etc/nginx/conf.d') do
        its('owner') { should be_in authorized_sa_user_list }
        its('group') { should be_in authorized_sa_group_list }
        it { should_not be_readable.by('others') }
        it { should_not be_writable.by('others') }
        it { should_not be_executable.by('others') }
      end
      describe file('/etc/nginx/conf.d') do
        it { should be_owned_by nginx_owner }
        its('group') { should cmp nginx_group }
        it { should_not be_executable }
        it { should_not be_readable.by('others') }
        it { should_not be_writable.by('others') }
      end
    end
    describe.one do
      describe file('/etc/nginx/modules') do
        its('owner') { should be_in authorized_sa_user_list }
        its('group') { should be_in authorized_sa_group_list }
        it { should_not be_readable.by('others') }
        it { should_not be_writable.by('others') }
        it { should_not be_executable.by('others') }
      end
      describe file('/etc/nginx/modules') do
        it { should be_owned_by nginx_owner }
        its('group') { should cmp nginx_group }
        it { should_not be_executable }
        it { should_not be_readable.by('others') }
        it { should_not be_writable.by('others') }
      end
      describe file('/etc/nginx/modules') do
        it { should_not exist }
      end
    end
    describe.one do
      describe file('/usr/share/nginx/html') do
        its('owner') { should be_in authorized_sa_user_list }
        its('group') { should be_in authorized_sa_group_list }
        it { should_not be_writable.by('others') }
      end
      describe file('/usr/share/nginx/html') do
        it { should be_owned_by nginx_owner }
        its('group') { should cmp nginx_group }
        it { should_not be_executable }
        it { should_not be_writable.by('others') }
      end
    end
    describe.one do
      describe file('/var/log/nginx') do
        its('owner') { should be_in authorized_sa_user_list }
        its('group') { should be_in authorized_sa_group_list }
        it { should_not be_writable.by('group') }
        it { should_not be_readable.by('others') }
        it { should_not be_writable.by('others') }
        it { should_not be_executable.by('others') }
      end
      describe file('/var/log/nginx') do
        it { should be_owned_by nginx_owner }
        its('group') { should cmp nginx_group }
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
