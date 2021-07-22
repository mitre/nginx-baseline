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

control "V-6724" do
  title "Web server and/or operating system information must be protected."

  desc "The web server response header of an HTTP response can contain several
  fields of information including the requested HTML page. The information
  included in this response can be web server type and version, operating
  system and version, and ports associated with the web server. This provides
  the malicious user valuable information without the use of extensive
  tools."

  impact 0.3
  tag "severity": "low"
  tag "gtitle": "WG520"
  tag "gid": "V-6724"
  tag "rid": "SV-36672r1_rule"
  tag "stig_id": "WG520 A22"
  tag "nist": ["CM-6", "Rev_4"]

  tag "check": "Enter the following command:

  grep ""server_tokens"" on the nginx.conf file and any separate included
  configuration files

  The Directive server_tokens must be set to ""off"" (ex. server_tokens off;).
  This directive disables emitting nginx version on error pages and in the
  “Server” response header field.

  If the web server or operating system information are sent to the client via
  the server response header or the directive does not exist, this is a finding.

  Note: The default value is set to on."

  tag "fix": "server_tokens must be set to 'off'."

  nginx_conf_file = input('nginx_conf_file')

  begin
    nginx_conf_handle = nginx_conf(nginx_conf_file)

    describe nginx_conf_handle do
      its ('params') { should_not be_empty }
    end

    nginx_conf_handle.http.entries.each do |http|
      describe http.params['server_tokens'] do
        it { should cmp [['off']] }
      end
    end

    nginx_conf_handle.servers.entries.each do |server|
      describe.one do
        describe server.params['server_tokens'] do
          it { should be nil }
        end
        describe server.params['server_tokens'] do
          it { should cmp [['off']] }
        end
      end
    end
    nginx_conf_handle.locations.entries.each do |location|
      describe.one do
        describe location.params['server_tokens'] do
          it { should be nil }
        end
        describe location.params['server_tokens'] do
          it { should cmp [['off']] }
        end
      end
    end

  rescue Exception => msg
    describe "Exception: #{msg}" do
      it { should be_nil }
    end
  end
end
