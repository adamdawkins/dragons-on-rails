apply "config/application.rb"
template "config/database.example.yml.tt"
remove_file "config/database.yml"
copy_file "config/puma.rb", force: true
remove_file "config/secrets.yml"

gsub_file "config/routes.rb", /  # root 'welcome#index'/ do
  '  root "home#index"'
end

copy_file "config/initializers/generators.rb"
copy_file "config/initializers/rotate_log.rb"
copy_file "config/initializers/version.rb"

apply "config/environments/development.rb"
apply "config/environments/production.rb"
apply "config/environments/test.rb"

if @include_sidekiq
  copy_file "config/sidekiq.yml"
  prepend_to_file "config/routes.rb" do
    %(require "sidekiq/web"\n\n)
  end
  route %Q(mount Sidekiq::Web => "/sidekiq" # monitoring console\n)
end


route 'root "home#index"'
