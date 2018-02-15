set :branch, ENV['BRANCH'] || "master"
set :stage, :production
set :rails_env, 'production'
set :unicorn_rack_env, 'production'
require 'pry'
require 'aws-sdk'
ec2 = Aws::EC2::Client.new(access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                           secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
                           region: ENV["AWS_REGION"])
ec2_filtered_web = ec2.describe_instances(
                 filters:[
                   {name: "tag:role", values: ['web']},
                   {name: "tag:deploy", values: ['production']},
                   {name: 'instance-state-name', values: ['running']}
                 ])
instances = ec2_filtered_web.reservations.map(&:instances).flatten.map(&:public_ip_address)
instances.each do |ip|
  server ip.to_s, port: ENV['SSH_PORT'], user: 'app', roles: %w{web app db}
end
set :ssh_options, {
    forward_agent: true,
    keys: [File.expand_path(ENV['DEPLOY_PRO_APP_KEY_PATH'])]
}
