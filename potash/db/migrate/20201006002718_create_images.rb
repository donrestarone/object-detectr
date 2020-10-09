class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.boolean :analyzing
      t.boolean :analysis_completed
      t.string :assertion

      t.timestamps
    end
  end
end
