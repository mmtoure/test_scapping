class CreateArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :articles do |t|
      t.string :en_vigueur
      t.string :methode
      t.text :contenu
      t.date :date_publication
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
