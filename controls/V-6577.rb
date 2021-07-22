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

control "V-6577" do

  title "A web server must be segregated from other services."

  desc"The web server installation and configuration plan should not support
  the co-hosting of multiple services such as Domain Name Service (DNS),
  e-mail, databases, search engines, indexing, or streaming media on the same
  server that is providing the web publishing service.By separating these
  services additional defensive layers are established between the web service
  and the applicable application should either be compromised.

  Disallowed or restricted services in the context of this vulnerability applies
  to services that are not directly associated with the delivery of web content.
  An operating system that supports a web server will not provide other services
  (e.g., domain controller, e-mail server, database server, etc.). Only those
  services necessary to support the web server and its hosted sites are
  specifically allowed and may include, but are not limited to, operating
  system, logging, anti-virus, host intrusion detection, administrative
  maintenance, or network requirements. "

  impact 0.5
  tag "severity": "medium"
  tag "gtitle": "WG204"
  tag "gid": "V-6577"
  tag "rid": "SV-32950r1_rule"
  tag "stig_id": "WG204 A22"
  tag "nist": ["SC-2", "Rev_4"]

  tag "check": "Request a copy of and review the web server’s installation and
  configuration plan. Ensure that the server is in compliance with this plan.
  If the server is not in compliance with the plan, this is a finding.

  Query the SA to ascertain if and where the additional services are installed.

  Confirm that the additional service or application is not installed on the
  same partition as the operating systems root directory or the web document
  root. If it is, this is a finding."

  tag "fix": "Request a copy of and review the web server’s installation and
  configuration plan. Ensure that the server is in compliance with this plan.
  If the server is not in compliance with the plan, this is a finding.

  Query the SA to ascertain if and where the additional services are installed.

  Confirm that the additional service or application is not installed on the
  same partition as the operating systems root directory or the web document
  root. If it is, this is a finding."

  nginx_conf_file = input('nginx_conf_file')

  begin
    # collect root directores from nginx_conf
    webserver_roots = []
    nginx_conf_handle = nginx_conf(nginx_conf_file)

    describe nginx_conf_handle do
      its ('params') { should_not be_empty }
    end

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

    services = command('systemctl list-unit-files --type service').stdout.scan(/^(.+).service/).flatten

    services.each do |service|
      service_path = service(service).params['ExecStart'].scan(/path=(.+)[\s][;][\s]argv/).join unless service(service).params['ExecStart'].nil?
      describe service_path do
        it { should_not cmp '/' }
      end
      webserver_roots.each do |root|
        describe service_path do
          it { should_not match root }
        end
      end
    end

    if services.empty?
      describe "Skip Message" do
        skip "Skipped: no services found."
      end
    end
  rescue Exception => msg
    describe "Exception: #{msg}" do
      it { should be_nil }
    end
  end

end
