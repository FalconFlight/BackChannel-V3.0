class AddTotalVotesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :total_votes, :integer
  end

  def self.down
    remove_column :users, :total_votes
  end
end
