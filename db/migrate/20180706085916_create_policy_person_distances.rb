class CreatePolicyPersonDistances < ActiveRecord::Migration[5.1]
  def change
    create_table :policy_person_distances do |t|
      t.references :policy, foreign_key: true
      t.integer :deputy_id
      t.integer :same, null: false, default: 0
      t.integer :diff, null: false, default: 0
      t.integer :absent, null: false, default: 0
      t.integer :same_strong, null: false, default: 0
      t.integer :diff_strong, null: false, default: 0
      t.integer :absent_strong, null: false, default: 0
      t.float :distance

      t.timestamps
    end
  end
end
