require 'net/ssh'
require 'ostruct'
require 'logger'

module SshExec

  @@log = Logger.new(STDOUT)
  @@log.level = Logger::INFO


  class ExecutionError < StandardError
    attr_reader :object

    def initialize(object)
      @object = object
    end
  end

  # Execute the given command using the given ssh object and
  # @param ssh the Net::SSH object connected to a host
  # @param options [Hash] optional flags:
  #   :echo_stdout - whether to echo stdout from the subcommand
  #   :echo_stderr - whether to echo stderr from the subcommand
  # @return [OpenStruct] a struct containing :stdout, :stderr, :exit_status, and :exit_signal
  def self.ssh_exec!(ssh, command, options = {})
    options = options.clone
    echo_stdout = options[:echo_stdout]
    echo_stderr = options[:echo_stderr]
    raise "Invalid options: #{options}" unless options.empty?

    stdout_data = ""
    stderr_data = ""
    exit_code = nil
    exit_signal = nil
    ssh.open_channel do |channel|
      channel.exec(command) do |ch, success|
        unless success
          raise "FAILED: couldn't execute command #{command}"
        end
        channel.on_data do |ch, data|
          stdout_data += data
          $stdout.write(data) if echo_stdout
        end

        channel.on_extended_data do |ch, type, data|
          stderr_data += data
          $stderr.write(data) if echo_stderr
        end

        channel.on_request("exit-status") do |ch, data|
          exit_code = data.read_long
        end

        channel.on_request("exit-signal") do |ch, data|
          exit_signal = data.read_long
        end
      end
    end
    ssh.loop
    OpenStruct.new(
      :stdout => stdout_data,
      :stderr => stderr_data,
      :exit_status => exit_code,
      :exit_signal => exit_signal
    )
  end

  def self.ensure_exec(ssh, command)
    result = ssh_exec!(ssh, command)

    if command.split("\n").length == 1
      @@log.info("Running on #{ssh.host}: #{command}")
    end

    if result.exit_status  != 0
      @@log.error(
        ("Failed running command #{command}: exit status #{result.exit_status}. " +
        (result.stdout.empty? ? "" : "Standard output:\n#{result.stdout}\n") +
        (result.stderr.empty? ? "" : "Standard error:\n#{result.stderr}")).strip
      )
      raise ExecutionError.new(
        "Failed running command #{command}: exit status #{result.exit_status}"
      )
    end
    result
  end

end
