class AuthGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  APP_NAME = Rails.application.class.parent.name

  APP_ROUTES_LINES =<<-EOS
  match '/auth/:provider/callback' => 'sessions#create'
  match "/signout" => "sessions#destroy", :as => :signout
  EOS

  APP_VIEW_LAYOUT_LINES =<<-EOS
  <% if current_user %>
    Welcome <%= current_user.name %>!
    <%= link_to "Sign Out", signout_path %>
  <% else %>
    <%= link_to "Sign in with Twitter", "/auth/twitter" %>
  <% end %>
  EOS

  APP_CONTROLLER_LINES =<<-EOS
  helper_method :current_user

  def current_user
    begin
      @current_user || User.find(session[:user_id]) if session[:user_id]
    rescue
      nil
    end
  end

  def authenticate
    redirect_to :root unless current_user
  end
  EOS

  GEM_FILE_LINES =<<-EOS
gem 'omniauth'
gem 'omniauth-twitter'
  EOS

  def install
    # gemfile
    append_to_file "Gemfile", GEM_FILE_LINES
    # copy initializer
    copy_file "omniauth.rb", "config/initializers/omniauth.rb"
    # session_controllerに追加
    copy_file "sessions_controller.rb", "app/controllers/sessions_controller.rb"
    # application controllerに追加
    inject_into_class "app/controllers/application_controller.rb", ApplicationController, APP_CONTROLLER_LINES
    # add user_model
    copy_file "user.rb", "app/models/user.rb"
    # session_controllerに追加
    copy_file "migration_create_users.rb", "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_users.rb"
    # application layout
    inject_into_file "app/views/layouts/application.html.erb", APP_VIEW_LAYOUT_LINES, :after => "<body>"
    # config/routes
    inject_into_file "config/routes.rb", APP_ROUTES_LINES, :after => "#{APP_NAME}::Application.routes.draw do\n"
  end
end
