class AddWeightToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :weight, :integer
    add_index :posts, :weight
  end

  def self.down
    remove_column :posts, :weight
    remove_index :posts, :weight
  end
end
