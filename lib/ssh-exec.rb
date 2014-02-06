require 'net/ssh'

module SshExec

  def self.ssh_exec!(ssh, command)
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
          $stdout.write(data)
        end

        channel.on_extended_data do |ch, type, data|
          stderr_data += data
          $stderr.write(data)
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

end
