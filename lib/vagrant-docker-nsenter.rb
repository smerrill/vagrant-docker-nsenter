# This file is required because Vagrant's plugin system expects
# an eponymous ruby file matching the rubygem.
#
# So this gem is called 'vagrant-docker-nsenter' and thus vagrant tries
# to require "vagrant-docker-nsenter"

require "vagrant-docker-nsenter/plugin"

require "pathname"

module VagrantPlugins
  module DockerNSEnter
    autoload :Errors, lib_path.join("errors")

    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end
  end
end
