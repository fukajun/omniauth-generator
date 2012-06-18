class AuthGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  APP_CONTROLLER_LINE =<<-EOS
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

  def install
    # session_controllerに追加
    copy_file "sessions_controller.rb", "app/controllers/sessions_controller.rb"

    # application controllerに追加
    inject_into_class "app/controllers/application_controller.rb", ApplicationController, APP_CONTROLLER_LINE

    # session_controllerに追加
    copy_file "migration_create_user.rb", "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_user.rb"
  end
end
