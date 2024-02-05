class ChangePendingDefaultInFollow < ActiveRecord::Migration[7.1]
  def change
    change_column_default(:follows, :pending, true)
  end
end
