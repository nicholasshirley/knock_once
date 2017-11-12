module KnockOnce
  class InstallGenerator < Rails::Generators::Base

    source_root File.expand_path("../../../templates", __FILE__)

    def create_user_model
      copy_file('user_model.rb', 'app/models/user.rb')
    end

    def copy_migrations
      if self.class.migration_exists?("db/migrate", "create_knock_once_users")
        say_status("skipped", "Migration create_knock_once_users already exists")
      else
        migration_template("create_knock_once_users.rb.erb", "db/migrate/create_knock_once_users.rb")
      end
    end
  end
end
