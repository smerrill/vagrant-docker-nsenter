require "vagrant"

module VagrantPlugins
  module DockerNSEnter
    module Errors
      class VagrantDockerNSEnterError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_docker_nsenter.errors")
      end

      class VagrantTooOld < VagrantDockerNSEnterError
        error_key(:vagrant_16_required)
      end
    end
  end
end

