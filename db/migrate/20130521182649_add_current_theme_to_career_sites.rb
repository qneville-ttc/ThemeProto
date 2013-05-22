class AddCurrentThemeToCareerSites < ActiveRecord::Migration
  def change
    add_column :career_sites, :current_theme_id, :integer
  end
end
