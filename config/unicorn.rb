worker_processes 1
preload_app true
main_dir = '/home/ec2-user/wedding-website/current'
working_directory '/home/ec2-user/wedding-website/current'
listen 8080, :tcp_nopush => true
listen "/tmp/shop.socket", :backlog => 2048
timeout 30
user 'ec2-user'
shared_path = "#{main_dir}/shared"
pid "#{shared_path}/pids/unicorn.pid"
stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"