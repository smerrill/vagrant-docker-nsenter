# This file is required because Vagrant's plugin system expects
# an eponymous ruby file matching the rubygem.
#
# So this gem is called 'vagrant-gatling-rsync' and thus vagrant tries
# to require "vagrant-gatling-rsync"

require "vagrant-docker-nsenter/plugin"

require "pathname"

module VagrantPlugins
  module DockerNSEnter
    #lib_path = Pathname.new(File.expand_path("../vagrant-docker-nsenter", __FILE__))
    #autoload :Errors, lib_path.join("errors")
    #autoload :ListenOSX, lib_path.join("listen/listenosx")
    #autoload :ListenLinux, lib_path.join("listen/listenlinux")

    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end
  end
end
