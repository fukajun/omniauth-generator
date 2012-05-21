class AuthGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  def install
    sessions_controller_code =<<-EOS
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
    create_file "controller/sesssions_controller.rb", sessions_controller_code
    copy_file "sesssions_controller.rb", "app/controller/sessions_controller.rb"
  end

end
