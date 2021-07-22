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

control "V-13727" do
  title "The worker_processes StartServers directive must be set properly."

  desc "These requirements are set to mitigate the effects of several types of
  denial of service attacks. Although there is some latitude concerning the
  settings themselves, the requirements attempt to provide reasonable limits
  for the protection of the web server. If necessary, these limits can be
  adjusted to accommodate the operational requirement of a given system."

  impact 0.5
  tag "severity": "medium"
  tag "gtitle": "WA000-WWA026"
  tag "gid": "V-13727"
  tag "rid": "SV-36645r2_rule"
  tag "stig_id": "WA000-WWA026 A22"
  tag "nist": ["CM-6", "Rev_4"]

  tag "check": "To view the worker_processes directive value enter the
  following command:

  grep ""worker_processes"" on the nginx.conf file and any separate included
  configuration files

  If the value of ""worker_processes"" is not set to auto or explicitly set,
  this is a finding:

  worker_processes   auto;

  worker_processes defines the number of worker processes. The optimal value
  depends on many factors including (but not limited to) the number of CPU
  cores, the number of hard disk drives that store data, and load pattern. When
  one is in doubt, setting it to the number of available CPU cores would be a
  good start (the value “auto” will try to autodetect it)."

  tag "fix": "Edit the configuration file and set the value of
  ""worker_processes"" to the value of auto or a value of 1 or higher:

  worker_processes auto;"

  nginx_conf_file = input('nginx_conf_file')

  begin
    describe nginx_conf(nginx_conf_file).params['worker_processes'] do
      it { should cmp [['auto']] }
    end
  rescue Exception => msg
    describe "Exception: #{msg}" do
      it { should be_nil }
    end
  end

end
