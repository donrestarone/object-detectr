class CreateImageAnalyses < ActiveRecord::Migration[6.0]
  def change
    create_table :image_analyses do |t|
      t.references :image, null: false, foreign_key: true

      t.timestamps
    end
  end
end
