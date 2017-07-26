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

ALLOWED_SERVICES_LIST= attribute(
  'allowed_services_list',
  description: 'Path for the nginx configuration file',
  default: ['brandbot',
            'dbus',
            'dracut-shutdown',
            'emergency',
            'getty@tty1',
            'kmod-static-nodes',
            'network',
            'nginx',
            'rc-local',
            'rescue',
            'rhel-autorelabel-mark',
            'rhel-autorelabel',
            'rhel-configure',
            'rhel-dmesg',
            'rhel-import-state',
            'rhel-loadmodules',
            'rhel-readonly',
            'serial-getty@ttyS0',
            'systemd-ask-password-console',
            'systemd-ask-password-wall',
            'systemd-binfmt',
            'systemd-firstboot',
            'systemd-fsck-root',
            'systemd-hwdb-update',
            'systemd-initctl',
            'systemd-journal-catalog-update',
            'systemd-journal-flush',
            'systemd-journald',
            'systemd-logind',
            'systemd-modules-load',
            'systemd-random-seed',
            'systemd-readahead-collect',
            'systemd-readahead-done',
            'systemd-readahead-replay',
            'systemd-reboot',
            'systemd-shutdownd',
            'systemd-sysctl',
            'systemd-tmpfiles-clean',
            'systemd-tmpfiles-setup-dev',
            'systemd-tmpfiles-setup',
            'systemd-udev-trigger',
            'systemd-udevd',
            'systemd-update-done',
            'systemd-update-utmp-runlevel',
            'systemd-update-utmp',
            'systemd-user-sessions',
            'systemd-vconsole-setup']
)

DISALLOWED_SERVICES_LIST= attribute(
  'disallowed_services_list',
  description: 'Path for the nginx configuration file',
  default: ['mysql',
            'postgres',
            'named'
           ]
)

only_if do
  command('nginx').exist?
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

  # collect root directores from nginx_conf
  webserver_roots = []

  if !nginx_conf(NGINX_CONF_FILE).http.nil?
    nginx_conf(NGINX_CONF_FILE).params['http'].each do |http|
      if !http['root'].nil?
        webserver_roots.push(http['root'].join)
      end
    end
  end

  if !nginx_conf(NGINX_CONF_FILE).http.nil?
    nginx_conf(NGINX_CONF_FILE).http.each do |http|
      if !http['server'].nil?
        http['server'].each do |server|
          if !server['root'].nil?
            webserver_roots.push(server['root'].join)
          end
          if !server['location'].nil?
            server['location'].each do |location|
              if !location['root'].nil?
                webserver_roots.push(location['root'].join)
              end
            end
          end
        end
      end
    end
  end

  services = command('systemctl -r --type service --all').stdout.scan(/^\s\s(.+).service/).flatten

  describe services do
    it{ should be_in ALLOWED_SERVICES_LIST}
  end

  describe services do
    it{ should_not be_in DISALLOWED_SERVICES_LIST}
  end

  services.each do |service|
    service_path = service(service).params['ExecStart'].scan(/path=(.+)[\s][;][\s]argv/).join
    describe service_path do
      it { should_not cmp '/'}
    end
    webserver_roots.each do |root|
      describe service_path do
        it { should_not match root}
      end
    end
  end
end
