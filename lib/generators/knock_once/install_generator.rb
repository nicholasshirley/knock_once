module KnockOnce
  class InstallGenerator < Rails::Generators::Base

    source_root File.expand_path("../../templates", __FILE__)
    # def generate_routes

    # end

    def create_user_model
      copy_file('user_model.rb', 'app/models/user.rb')
    end
  end
end
