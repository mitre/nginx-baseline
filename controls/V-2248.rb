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

control "V-2248" do

  title "Web administration tools must be restricted to the web manager and
  the web manager’s designees."

  desc"All automated information systems are at risk of data loss due to
  disaster or compromise. Failure to provide adequate protection to the
  administration tools creates risk of potential theft or damage that may
  ultimately compromise the mission.Adequate protection ensures that server
  administration operates with less risk of losses or operations outages.The
  key web service administrative and configuration tools must be accessible
  only by the authorized web server administrators. All users granted this
  authority must be documented and approved by the ISSO. Access to the IIS
  Manager will be limited to authorized users and administrators."

  impact 0.5
  tag "severity": "medium"
  tag "gtitle": "WG220"
  tag "gid": "V-2248"
  tag "rid": "SV-32948r2_rule"
  tag "stig_id": "WG220 A22"
  tag "nist": ["AC-3", "AC-6", "Rev_4"]

  tag "check": "Determine which tool or control file is used to control the
  configuration of the web server.

  If the control of the web server is done via control files, verify who has
  update access to them. If tools are being used to configure the web server,
  determine who has access to execute the tools.

  If accounts other than the SA, the web manager, or the web manager designees
  have access to the web administration tool or control files, this is a
  finding. "

  tag "fix": "Determine which tool or control file is used to control the
  configuration of the web server.

  If the control of the web server is done via control files, verify who has
  update access to them. If tools are being used to configure the web server,
  determine who has access to execute the tools.

  If accounts other than the SA, the web manager, or the web manager designees
  have access to the web administration tool or control files, this is a
  finding. "

  nginx_conf_file = input('nginx_conf_file')

  nginx_owner = input('nginx_owner')

  sys_admin = input('sys_admin')

  nginx_conf_file = input('nginx_conf_file')

  nginx_group = input('nginx_group')

  sys_admin_group = input('sys_admin_group')

  begin

    authorized_sa_user_list = sys_admin.clone << nginx_owner
    authorized_sa_group_list = sys_admin_group.clone << nginx_group

    nginx_conf_handle = nginx_conf(nginx_conf_file)
    nginx_conf_handle.params

    describe nginx_conf_handle do
      its ('params') { should_not be_empty }
    end

    nginx_conf_handle.contents.keys.each do |file|
      describe file(file) do
        its('owner') { should be_in authorized_sa_user_list }
        its('group') { should be_in authorized_sa_group_list }
        it { should_not be_executable }
        it { should_not be_readable.by('others') }
        it { should_not be_writable.by('others') }
      end
    end

    if nginx_conf_handle.contents.keys.empty?
      describe "Skip Message" do
        skip "Skipped: no conf files included."
      end
    end
  rescue Exception => msg
    describe "Exception: #{msg}" do
      it { should be_nil }
    end
  end
end
