
control 'nginx-service-check' do
  title 'Ensure the NGINX Service is configured and running'
  impact 0.9
  desc 'Ensure the NGINX Service is configured correctly and setup correctly'

  tag nist: ['CM-6', 'Rev_4']

  describe "The NGINX service for levels 3 - 5" do
    subject { service('nginx').runlevels(3, 5) }
    it { should be_enabled }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
    it { should be_installed }
  end
end
