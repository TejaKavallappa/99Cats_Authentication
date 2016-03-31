class SessionsTable < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :session_token
      t.id :user_id, presence: true

      t.timestamps
    end

    remove_column :users, :session_token
    remove_index :users, :session_token
  end
end
