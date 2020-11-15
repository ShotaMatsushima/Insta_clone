class RemoveIntroductionFromusers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :Introduction, :string
  end
end
