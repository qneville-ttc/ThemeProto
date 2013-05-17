class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.integer :theme_id
      t.text :content
      t.string :permalink
      t.integer :career_site_id

      t.timestamps
    end
  end
end
