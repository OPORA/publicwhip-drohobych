class AddPolicyDivisionToVersions < ActiveRecord::Migration[5.1]
  def change
    add_column :versions, :policy_id, :integer
    add_column :versions, :division_id, :integer
  end
end
