begin
    require "vagrant"
rescue LoadError
    raise "The Vagrant docker-nsenter plugin must be run within Vagrant."
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.6.0"
  raise Errors::VagrantTooOld
end

module VagrantPlugins
  module DockerNSEnter
    class Plugin < Vagrant.plugin("2")
      name "docker-nsenter"
      description <<-EOF
      The vagrant-docker-nsenter plugin lets you run commands in containers
      that are not running SSH.
      EOF

      command "docker-nsenter" do
        require_relative "command/nsenter"
        #init!
        Command::NSEnter
      end

      #protected

      #def self.init!
        #return if defined?(@_init)
        #I18n.load_path << File.expand_path(
          #"templates/locales/providers_docker.yml", Vagrant.source_root)
        #I18n.reload!
        #@_init = true
      #end
    end
  end
end
