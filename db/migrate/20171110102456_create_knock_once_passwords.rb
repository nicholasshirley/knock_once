class CreateKnockOncePasswords < ActiveRecord::Migration[5.1]
  def change
    create_table :knock_once_passwords do |t|

      t.timestamps
    end
  end
end
