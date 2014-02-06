## ssh-exec

`ssh-exec` is a wrapper around Net::SSH based on a
[StackOverflow answer](http://stackoverflow.com/questions/3386233/how-to-get-exit-status-with-rubys-netssh-library/3386375#3386375),
allowing to easily capture standard output, standard error, and the exit code
of a command executed over [Net::SSH](https://github.com/net-ssh/net-ssh).

### Examples

```ruby
require 'net/ssh'
require 'ssh-exec'

Net::SSH.start('somehost', 'someuser') do |ssh|
  result = SshExec.ssh_exec!(ssh, 'echo I am remote host')
  puts result.stdout  # "I am remote host"
  puts result.stderr  # ""
  puts result.exit_status  # 0

  result = SshExec.ssh_exec!(ssh, 'false')
  puts result.exit_status  # 1
end
```

### License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)

