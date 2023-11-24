class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :zipcode
      t.string :password_digest
      t.string :avatar, default: "https://cdn-icons-png.flaticon.com/512/10017/10017692.png"
      t.integer :posts_viewed_count, default: 0

      t.timestamps
    end
  end
end
