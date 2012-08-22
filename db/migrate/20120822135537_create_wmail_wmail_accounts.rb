class CreateWmailWmailAccounts < ActiveRecord::Migration
  def change
    create_table :wmail_wmail_accounts do |t|
      t.integer :user_id
      t.string :user_email

      t.timestamps
    end
  end
end
