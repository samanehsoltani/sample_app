class ChangeColumnNameResetSentAr < ActiveRecord::Migration
  def change
    rename_column :users, :reset_sent_ar, :reset_sent_at
  end
end
