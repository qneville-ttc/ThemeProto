class CreateZipFiles < ActiveRecord::Migration
  def change
    create_table :zip_files do |t|

      t.timestamps
    end
  end
end
