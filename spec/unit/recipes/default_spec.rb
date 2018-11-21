#
# Cookbook:: kibana_nginx
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'kibana_nginx::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it "runs apt get update" do
      expect(chef_run).to update_apt_update 'update_sources'
    end

    it "should install nginx" do
      expect(chef_run).to install_package 'nginx'
    end

    it "should start service nginx" do
      expect(chef_run).to start_service 'nginx'
    end

    it "should enable service nginx" do
      expect(chef_run).to enable_service 'nginx'
    end

    it "should create file proxy.conf in /etc/nginx/sites-available/" do
      expect(chef_run).to create_template ('/etc/nginx/sites-available/proxy.conf')
    end

   it "should create file kibana.yml in /etc/kibana/" do
      expect(chef_run).to create_template('/etc/kibana/kibana.yml')
    end

    it 'should enable the kibana service' do
      expect(chef_run).to enable_service "kibana"
    end

    it 'should start the kibana service' do
      expect(chef_run).to start_service "kibana"
    end
  end
end
