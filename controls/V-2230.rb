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

control 'V-2230' do

  title 'Backup interactive scripts on the production web server are prohibited.'

  desc  "Copies of backup files will not execute on the server, but they can
  be read by the anonymous user if special precautions are not taken. Such
  backup copies contain the same sensitive information as the actual script
  being executed and, as such, are useful to malicious users. Techniques and
  systems exist today that search web servers for such files and are able to
  exploit the information contained in them."

  impact 0.3
  tag "severity": "low"
  tag "gtitle": "WG420"
  tag "gid": "V-2230"
  tag "rid": "SV-6930r1_rule"
  tag "stig_id": "WG420 A22"
  tag "nist": ["CM-6", "Rev_4"]

  tag "check": "Search for backup copies of CGI scripts on the web server or
  ask the SA or the Web Administrator if they keep backup copies of CGI
  scripts on the web server.

  Common backup file extensions are: *.bak, *.old, *.temp, *.tmp, *.backup, .?*

  Commands to help find: find /nginx -name '.?*' -not -name .ht* -or -name '*~'
  -or -name '*

   find /usr/local/nginx/html/ -name '.?*' -not-name.ht* -or-name '*~' -or-name '*.bak
   *' -or-name '*.old*'

  If files with these extensions are found in either the document directory or
  the home directory of the web server, this is a finding.

  If files with these extensions are stored in a repository (not in the document
  root) as backups for the web server, this is a finding.

  If files with these extensions have no relationship with web activity, such as
  a backup batch file for operating system utility, and they are not accessible
  by the web application, this is not a finding.  "

  tag "fix": "Ensure that CGI backup scripts are not left on the production
  web server."

  nginx_conf_file = input('nginx_conf_file')

  nginx_backup_repository = input('nginx_backup_repository')

  begin
    dirs = ['/home', nginx_backup_repository]

    nginx_conf_handle = nginx_conf(nginx_conf_file)

    describe nginx_conf_handle do
      its ('params') { should_not be_empty }
    end

    nginx_conf_handle.http.entries.each do |http|
      dirs.push(http.params['root']) unless http.params['root'].nil?
    end

    nginx_conf_handle.servers.entries.each do |server|
      dirs.push(server.params['root']) unless server.params['root'].nil?
    end

    nginx_conf_handle.locations.entries.each do |location|
      dirs.push(location.params['root']) unless location.params['root'].nil?
    end

    dirs.flatten!
    dirs.uniq!

    dirs.each do |dir|
      next unless directory(dir).exist?
      describe "List of backup NINGX and/or CGI scripts found in #{dir}" do
        subject { command("find #{dir} -name '.?*' -not-name '.ht*' -or-name '*~' -or-name '*.bak' -or-name '*.old*'").stdout.chomp.split }
        it { should be_empty }
      end
    end
  rescue Exception => msg
    describe "Exception: #{msg}" do
      it { should be_nil }
    end
  end
end
