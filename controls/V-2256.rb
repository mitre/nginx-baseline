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

control "V-2256" do
  title "The access control files are owned by a privileged web server account."

  desc " This check verifies that the key web server system configuration files
  are owned by the SA or Web Manager controlled account. These same files
  which control the configuration of the web server, and thus its behavior,
  must also be accessible by the account which runs the web service. If these
  files are altered by a malicious user, the web server would no longer be
  under the control of its managers and owners; properties in the web server
  configuration could be altered to compromise the entire server platform."

  impact 0.5
  tag "severity": "medium"
  tag "gtitle": "WG280"
  tag "gid": "V-2256"
  tag "rid": "SV-6880r1_rule"
  tag "stig_id": "WG280"
  tag "nist": ["AC-3", "Rev_4"]

  tag "check": "This check verifies that the SA or Web Manager controlled
  account owns the key web server files. These same files, which control the
  configuration of the web server, and thus its behavior, must also be
  accessible by the account that runs the web service process.

  If it exists, the following file need to be owned by a privileged account.

  .htaccess .htpasswd nginx.conf and its included configuration files

  Use the command find / -name nginx.conf to find the file.  grep ""include"" on
  the nginx.conf file to identify included configuration files. Change to the
  directories that contain the nginx.conf and included configuration files. Use
  the command ls -l on these files to determine ownership of the file

  -The Web Manager or the SA should own all the system files and directories.
  -The configurable directories can be owned by the WebManager or equivalent
  -user.

  Permissions on these files should be 660 or more restrictive.

  If root or an authorized user does not own the web system files and the
  permission are not correct, this is a finding."

  tag "fix": "The site needs to ensure that the owner should be the non-
  privileged web server account or equivalent which runs the web service;
  however, the group permissions represent those of the user accessing the web
  site that must execute the directives in .htacces."

  nginx_conf_file = input('nginx_conf_file')
  
  nginx_owner = input('nginx_owner')

  sys_admin = input('sys_admin')

  nginx_group = input('nginx_group')

  sys_admin_group = input('sys_admin_group')

  begin

    authorized_sa_user_list = sys_admin.clone << nginx_owner
    authorized_sa_group_list = sys_admin_group.clone << nginx_group
    
    access_control_files = [ '.htaccess',
                            '.htpasswd']

    nginx_conf_handle = nginx_conf(nginx_conf_file)
    nginx_conf_handle.params
    
    describe nginx_conf_handle do
      its ('params') { should_not be_empty }
    end

    access_control_files.each do |file|
      file_path = command("find / -name #{file}").stdout.chomp

      if file_path.empty?
        describe "Skip Message" do
          skip "Skipped: Access control file #{file} not found"
        end
      end

      file_path.split.each do |file|
        describe file(file) do
        its('owner') { should be_in authorized_sa_user_list }
        its('group') { should be_in authorized_sa_group_list }
        it { should_not be_executable }
        it { should_not be_readable.by('others') }
        it { should_not be_writable.by('others') }
        end
      end
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

    webserver_roots = []

    nginx_conf_handle.http.entries.each do |http|
      webserver_roots.push(http.params['root']) unless http.params['root'].nil?
    end

    nginx_conf_handle.servers.entries.each do |server|
      webserver_roots.push(server.params['root']) unless server.params['root'].nil?
    end

    nginx_conf_handle.locations.entries.each do |location|
      webserver_roots.push(location.params['root']) unless location.params['root'].nil?
    end

    webserver_roots.flatten!
    webserver_roots.uniq!

    webserver_roots.each do |directory|
      describe file(directory) do
        its('owner') { should be_in authorized_sa_user_list }
        its('group') { should be_in authorized_sa_group_list }
        its('sticky'){ should be true }
      end
    end

    if webserver_roots.empty?
      describe "Skip Message" do
        skip "Skipped: no web root directories found."
      end
    end

  rescue Exception => msg
    describe "Exception: #{msg}" do
      it { should be_nil }
    end
  end

end
