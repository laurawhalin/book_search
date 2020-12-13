class CreateSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :searches do |t|
      t.string :title
      t.string :author
      t.datetime :refreshed_at

      t.timestamps
    end

    add_index(:searches, [:author, :title], unique: true)
  end
end
