class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
    add_index :votes, [:user_id, :post_id]
  end

  def self.down
    remove_index :votes, [:user_id, :post_id]
    drop_table :votes
  end
end
