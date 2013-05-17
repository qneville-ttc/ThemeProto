class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :theme_name
      t.text :theme_desc
      t.integer :career_site_id
      t.string :theme_filename

      t.timestamps
    end
  end
end
