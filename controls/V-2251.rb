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
            'systemd-vconsole-setup',
            'auditd',
            "autovt@",
            "blk-availability",
            "console-getty",
            "console-shell",
            "container-getty@",
            "dbus-org.freedesktop.hostname1",
            "dbus-org.freedesktop.import1",
            "dbus-org.freedesktop.locale1",
            "dbus-org.freedesktop.login1",
            "dbus-org.freedesktop.machine1",
            "dbus-org.freedesktop.timedate1",
            "debug-shell",
            "dracut-cmdline",
            "dracut-initqueue",
            "dracut-mount",
            "dracut-pre-mount",
            "dracut-pre-pivot",
            "dracut-pre-trigger",
            "dracut-pre-udev",
            "fstrim",
            "getty@",
            "halt-local",
            "initrd-cleanup",
            "initrd-parse-etc",
            "initrd-switch-root",
            "initrd-udevadm-cleanup-db",
            "messagebus",
            "nginx-debug",
            "qemu-guest-agent",
            "quotaon",
            "rdisc",
            "rhel-domainname",
            "serial-getty@",
            "systemd-backlight@",
            "systemd-bootchart",
            "systemd-fsck@",
            "systemd-halt",
            "systemd-hibernate-resume@",
            "systemd-hibernate",
            "systemd-hostnamed",
            "systemd-hybrid-sleep",
            "systemd-importd",
            "systemd-kexec",
            "systemd-localed",
            "systemd-machine-id-commit",
            "systemd-machined",
            "systemd-nspawn@",
            "systemd-poweroff",
            "systemd-quotacheck",
            "systemd-readahead-drop",
            "systemd-remount-fs",
            "systemd-rfkill@",
            "systemd-suspend",
            "systemd-timedated",
            "systemd-udev-settle"]
)

DISALLOWED_SERVICES_LIST= attribute(
  'disallowed_services_list',
  description: 'List of disallowed servies',
  default: ['mysql',
            'postgres',
            'named'
           ]
)

ALLOWED_PACKAGES_LIST= attribute(
  'allowed_packages_list',
  description: 'List of allowed packages',
  default: [ "centos-release",
             "filesystem",
             "basesystem",
             "nss-softokn-freebl",
             "glibc",
             "libstdc++",
             "bash",
             "pcre",
             "zlib",
             "xz-libs",
             "libcom_err",
             "popt",
             "sed",
             "elfutils-libelf",
             "libffi",
             "libattr",
             "libacl",
             "libuuid",
             "readline",
             "gawk",
             "libcap-ng",
             "sqlite",
             "findutils",
             "expat",
             "nss-softokn",
             "p11-kit",
             "file-libs",
             "hostname",
             "tar",
             "pinentry",
             "libdb-utils",
             "libss",
             "elfutils-default-yama-scope",
             "ncurses",
             "gmp",
             "libsemanage",
             "libtasn1",
             "ca-certificates",
             "openssl-libs",
             "libblkid",
             "libmount",
             "shared-mime-info",
             "cracklib",
             "libpwquality",
             "pkgconfig",
             "dbus-glib",
             "binutils",
             "curl",
             "rpm",
             "libuser",
             "hardlink",
             "qrencode-libs",
             "device-mapper",
             "cryptsetup-libs",
             "dbus",
             "gdbm",
             "python",
             "dbus-python",
             "pyliblzma",
             "yum-metadata-parser",
             "python-urlgrabber",
             "pyxattr",
             "python-kitchen",
             "gnupg2",
             "pygpgme",
             "rpm-python",
             "yum",
             "yum-plugin-ovl",
             "passwd",
             "vim-minimal",
             "gpg-pubkey",
             "libmnl",
             "iptables",
             "sysvinit-tools",
             "systemd",
             "initscripts",
             "which",
             "nss-sysinit",
             "kmod",
             "kmod-libs",
             "openssl",
             "audit",
             "nginx",
             "libgcc",
             "setup",
             "bind-license",
             "ncurses-base",
             "glibc-common",
             "nspr",
             "ncurses-libs",
             "libsepol",
             "libselinux",
             "info",
             "bzip2-libs",
             "libdb",
             "chkconfig",
             "nss-util",
             "libxml2",
             "libgpg-error",
             "libcap",
             "grep",
             "libgcrypt",
             "lua",
             "cpio",
             "audit-libs",
             "libidn",
             "diffutils",
             "dbus-libs",
             "libassuan",
             "xz",
             "keyutils-libs",
             "acl",
             "cyrus-sasl-lib",
             "elfutils-libs",
             "ustr",
             "libverto",
             "p11-kit-trust",
             "coreutils",
             "krb5-libs",
             "shadow-utils",
             "glib2",
             "gzip",
             "cracklib-dicts",
             "pam",
             "procps-ng",
             "gobject-introspection",
             "libutempter",
             "libssh2",
             "nss-pem",
             "libcurl",
             "rpm-libs",
             "openldap",
             "util-linux",
             "kpartx",
             "device-mapper-libs",
             "dracut",
             "iputils",
             "python-libs",
             "python-iniparse",
             "python-pycurl",
             "python-gobject-base",
             "libxml2-python",
             "python-chardet",
             "pth",
             "gpgme",
             "rpm-build-libs",
             "yum-plugin-fastestmirror",
             "yum-utils",
             "qemu-guest-agent",
             "rootfiles",
             "libnfnetlink",
             "libnetfilter_conntrack",
             "iproute",
             "systemd-libs",
             "systemd-sysv",
             "lsof",
             "nss",
             "nss-tools",
             "tzdata",
             "make",
             "tcp_wrappers-libs",
             "gpg-pubkey",
	     "unzip",
             "wget"]
)

DISALLOWED_PACKAGES_LIST= attribute(
  'disallowed_packages_list',
  description: 'List of disallowed packages',
  default: [ ]
)

only_if do
  package('nginx').installed? || command('nginx').exist?
end

control "V-2251" do

  title "All utility programs, not necessary for operations, must be removed
  or disabled. "

  desc  "Just as running unneeded services and protocols is a danger to the
  web server at the lower levels of the OSI model, running unneeded utilities
  and programs is also a danger at the application layer of the OSI model.
  Office suites, development tools, and graphical editors are examples of such
  programs that are troublesome. Individual productivity tools have no
  legitimate place or use on an enterprise, production web server and they are
  also prone to their own security risks."

  impact 0.3
  tag "severity": "low"
  tag "gtitle": "WG130"
  tag "gid": "V-2251"
  tag "rid": "SV-32955r2_rule"
  tag "stig_id": "WG130 A22"
  tag "nist": ["CM-6", "Rev_4"]

  tag "check": "If the site requires the use of a particular piece of
  software, the ISSO will need to maintain documentation identifying this
  software as necessary for operations. The software must be operated at the
  vendor’s current patch level and must be a supported vendor release. If
  programs or utilities that meet the above criteria are installed on the Web
  Server, and appropriate documentation and signatures are in evidence, this is
  not a finding.

  Determine whether the web server is configured with unnecessary software.

  Determine whether processes other than those that support the web server are
  loaded and/or run on the web server.

  Examples of software that should not be on the web server are all web
  development tools, office suites (unless the web server is a private web
  development server), compilers, and other utilities that are not part of the
  web server suite or the basic operating system.

  Check the directory structure of the server and ensure that additional,
  unintended, or unneeded applications are not loaded on the system.

  If, after review of the application on the system, there is no justification
  for the identified software, this is a finding."

  tag "fix": "Remove any unnecessary applications."


  begin
    services = command('systemctl list-unit-files --type service').stdout.scan(/^(.+).service/).flatten

    describe services do
      it{ should be_in ALLOWED_SERVICES_LIST}
    end

    describe services do
      it{ should_not be_in DISALLOWED_SERVICES_LIST}
    end

    describe packages(/.*/) do
      its('names') { should be_in ALLOWED_PACKAGES_LIST }
    end

    describe packages(/.*/) do
      its('names') { should_not be_in DISALLOWED_PACKAGES_LIST }
    end

  rescue Exception => msg
    describe "Exception: #{msg}" do
      it { should be_nil }
    end
  end
end
