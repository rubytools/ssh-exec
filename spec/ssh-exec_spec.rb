require 'spec_helper'

describe 'SshExec' do
  include SshHelpers

  describe 'SshExec.ssh_exec!' do

    it 'capture_streams' do
      ssh_localhost do |ssh|
        result = SshExec.ssh_exec!(ssh,
          'echo Hello Stdout; echo Hello Stderr >&2'
        )
        expect(result.stdout).to eq("Hello Stdout\n")
        expect(result.stderr).to eq("Hello Stderr\n")
        expect(result.exit_status).to eq(0)
        expect(result.exit_signal).to be_nil
      end
    end

    it 'exit_status' do
      ssh_localhost do |ssh|
        [0, 1, 127, 128, 255].each do |status|
          expect(SshExec.ssh_exec!(ssh, "exit #{status}").exit_status).to eq(status)
        end
      end
    end

  end

  describe 'SshExec.ensure_exec' do
    it 'not_raise_on_success' do
      ssh_localhost do |ssh|
        result = SshExec.ensure_exec(ssh, 'echo Hello Stdout; echo Hello Stderr >&2')
        expect(result.stdout).to eq("Hello Stdout\n")
        expect(result.stderr).to eq("Hello Stderr\n")
        expect(result.exit_status).to eq(0)
        expect(result.exit_signal).to be_nil
      end
    end

    it 'raise_on_failure' do
      ssh_localhost do |ssh|
        expect { SshExec.ensure_exec(ssh, 'exit 1') }.to raise_error(SshExec::ExecutionError)
      end
    end
  end

end
