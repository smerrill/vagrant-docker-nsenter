module VagrantPlugins
  module DockerNSEnter
    module Command
      class NSEnter < Vagrant.plugin("2", :command)
        def self.synopsis
          "Use nsenter to start a command in a running container."
        end

        def execute
          options = {}
          options[:detach] = false
          options[:pty] = false

          opts = OptionParser.new do |o|
            o.banner = "Usage: vagrant docker-nsenter [command...]"
          end

          # Parse out the extra args to send to SSH, which is everything
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

          # Show the error if we don't have "--" _after_ parse_options
          # so that "-h" and "--help" work properly.
          if !split_index
            #@env.ui.error(I18n.t("docker_provider.run_command_required"))
            return 1
          end

          target_opts = { provider: :docker }
          target_opts[:single_target] = options[:pty]

          with_target_vms(argv, target_opts) do |machine|
            # Run it!
            execute_single(machine, options)
          end
          0
        end

        protected

        # Executes the "docker logs" command on a single machine and proxies
        # the output to our UI.
        def execute_single(machine, options)
          # @TODO: Check to see if the proxy VM has `nsenter` installed.
          command = ["docker", "inspect", "--format", "{{.State.Pid}}", machine.id]

          machine.provider.driver.execute(*command) do |type, data|
            puts data
          end

          #command = ["nsenter"]
          #command << machine.id

          #output_options = {}
          #output_options[:prefix] = false if !options[:prefix]

          #data_acc = ""
          #machine.provider.driver.execute(*command) do |type, data|
            ## Accumulate the data so we only output lines at a time
            #data_acc << data

            ## If we have a newline, then output all the lines we have so far
            #if data_acc.include?("\n")
              #lines    = data_acc.split("\n")

              #if !data_acc.end_with?("\n")
                #data_acc = lines.pop.chomp
              #else
                #data_acc = ""
              #end

              #lines.each do |line|
                #line = " " if line == ""
                #machine.ui.output(line, **output_options)
              #end
            #end
          #end

          ## Output any remaining data
          #machine.ui.output(data_acc, **output_options) if !data_acc.empty?
        end
      end
    end
  end
end
