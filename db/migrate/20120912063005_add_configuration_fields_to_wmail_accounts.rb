class AddConfigurationFieldsToWmailAccounts < ActiveRecord::Migration
  def change
    add_column :wmail_wmail_accounts, :account_type, :string
    add_column :wmail_wmail_accounts, :server, :string
    add_column :wmail_wmail_accounts, :port, :integer
    add_column :wmail_wmail_accounts, :enable_ssl, :boolean
  end
end
