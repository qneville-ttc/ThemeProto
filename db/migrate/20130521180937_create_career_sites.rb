class CreateCareerSites < ActiveRecord::Migration
  def change
    create_table :career_sites do |t|
      t.string :name

      t.timestamps
    end
  end
end
