class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.integer :category_id, null: false
      t.string :title, null: false
      t.text :body, null: false

      t.timestamps

      t.index :category_id

      t.foreign_key :categories, on_delete: :cascade
    end
  end
end
