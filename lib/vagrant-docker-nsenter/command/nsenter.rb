module VagrantPlugins
  module DockerNSEnter
    module Command
      class NSEnter < Vagrant.plugin("2", :command)
        def self.synopsis
          "Use nsenter to start a command in a running container."
        end

        def execute
          options = {}
          options[:interactive] = true

          opts = OptionParser.new do |o|
            o.banner = "Usage: vagrant docker-nsenter [command...]"
            o.separator ""
            o.separator "Options:"
            o.separator ""

            o.on("--[no-]interactive", "Run the command interactively") do |i|
              options[:interactive] = i
            end
          end

          # Parse out the extra args to send to nsenter, which is everything
          # after the "--"
          command     = nil
          split_index = @argv.index("--")
          if split_index
            command = @argv.drop(split_index + 1)
            @argv   = @argv.take(split_index)
          end

          # Parse the options
          argv = parse_options(opts)
          return if !argv

          # Assume /bin/bash if no command is provided.
          if !split_index
            command = "/bin/bash"
          end

          target_opts = { provider: :docker }
          target_opts[:single_target] = options[:pty]

          with_target_vms(argv, target_opts) do |machine|
            # Run it!
            execute_single(machine, options, command)
          end
          0
        end

        protected

        # Gets the PID of the container and then runs the command in it via
        # "sudo nsenter." Note that boot2docker does not currently ship with
        # nsenter, so this will only work with other proxy VMs.
        def execute_single(machine, options, command)
          # @TODO: Check to see if the proxy VM has `nsenter` installed.
          pid_command = ["docker", "inspect", "--format", "{{.State.Pid}}", machine.id]

          pid = 0
          pid_data = ""
          machine.provider.driver.execute(*pid_command, options) do |type, data|
            pid_data += data
          end
          # @TODO: Error handling.
          pid = pid_data.to_i.to_s

          nsenter_command = ["sudo", "nsenter", "-m", "-u", "-n", "-i", "-p", "-t", pid, "--"].concat(command)

          # Run this interactively if asked.
          nsenter_options = options
          nsenter_options[:stdin] = true if options[:interactive]

          nsenter_data = ""
          machine.provider.driver.execute(*nsenter_command, nsenter_options) do |type, data|
            nsenter_data += data
          end
          puts nsenter_data

          exit 0 if options[:interactive]
        end
      end
    end
  end
end
