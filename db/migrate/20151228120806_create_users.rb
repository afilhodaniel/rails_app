class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.attachment :avatar
      t.string     :name,               null: false
      t.text       :bio
      t.string     :username,           null: false
      t.string     :email,              null: false
      t.string     :encrypted_password, null: false
      t.integer    :level,              null: false, default: User::USER_LEVEL

      t.timestamps null: false
    end

    add_index :users, :username, unique: true
    add_index :users, :email,    unique: true
  end
end
