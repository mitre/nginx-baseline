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

control "V-13724" do
  title "The client body and header timeout directives must be properly set."

  desc "The timeout requirements are set to mitigate the effects of several
  types of denial of service attacks. Although there is some latitude
  concerning the settings themselves, the requirements attempt to provide
  reasonable limits for the protection of the web server. If necessary, these
  limits can be adjusted to accommodate the operational requirement of a given
  system.

  client_body_timeout defines a timeout for reading client request body. The
  timeout is set only for a period between two successive read operations, not
  for the transmission of the whole request body. If a client does not transmit
  anything within this time, the 408 (Request Time-out) error is returned to the
  client.

  client_header_timeout defines a timeout for reading client request header. If
  a client does not transmit the entire header within this time, the 408
  (Request Time-out) error is returned to the client. "

  impact 0.5
  tag "severity": "medium"
  tag "gtitle": "WA000-WWA020"
  tag "gid": "V-13724"
  tag "rid": "SV-32977r1_rule"
  tag "stig_id": "WA000-WWA020 A22"
  tag "nist": ["CM-6", "Rev_4"]

  tag "check": "To view the timeout values enter the following commands:

  grep ""client_body_timeout"" on the nginx.conf file and any separate included
  configuration files

  grep ""client_header_timeout"" on the nginx.conf file and any separate
  included configuration files

  If the values of each are not set to 10 seconds (10s) or less, this is a
  finding."


  tag "fix": "Edit the configuration file and set the value of 10 seconds or
  less:

  client_body_timeout   10s;

  client_header_timeout 10s;"

  nginx_conf_file = input('nginx_conf_file')

  begin
    nginx_conf_handle = nginx_conf(nginx_conf_file)

    describe nginx_conf_handle do
      its ('params') { should_not be_empty }
    end

    nginx_conf_handle.http.entries.each do |http|
      describe http.params['client_header_timeout'] do
        it { should_not be_nil }
      end
      describe http.params['client_header_timeout'].flatten do
        it { should cmp <= 10 }
      end unless http.params['client_header_timeout'].nil?

      describe http.params['client_body_timeout'] do
        it { should_not be_nil }

      end
      describe http.params['client_body_timeout'].flatten do
        it { should cmp <= 10 }
      end unless http.params['client_body_timeout'].nil?
    end

    nginx_conf_handle.servers.entries.each do |server|
      describe server.params['client_header_timeout'].flatten do
        it { should cmp <= 10 }
      end unless server.params['client_header_timeout'].nil?
      describe server.params['client_body_timeout'].flatten do
        it { should cmp <= 10 }
      end unless server.params['client_body_timeout'].nil?
    end


  rescue Exception => msg
    describe "Exception: #{msg}" do
      it { should be_nil }
    end
  end
end
