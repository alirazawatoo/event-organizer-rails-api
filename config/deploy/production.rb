#app
server '18.189.139.245', user: 'ubuntu', roles: %w{app db web}

set :branch, 'main'
set :deploy_to, '/var/www/Event-Management'
set :stage, :production
set :rails_env, 'production'
