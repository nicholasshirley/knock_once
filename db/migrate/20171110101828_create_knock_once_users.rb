class CreateKnockOnceUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :knock_once_users do |t|
      # Required
      t.string :email
      t.string :password_digest
      t.string :password_reset_token
      t.datetime :password_token_expiry

      # Add your custom user fields are required
      # TODO add whitelist instructions here

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
