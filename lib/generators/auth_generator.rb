class AuthGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  def install
    sessions_controller_code <<-EOS
class SessionsContoller < Rails::Genertors::Base
end
    EOS
    create_file "controller/sesssions_controller.rb", sessions_controller_code
  end

end
