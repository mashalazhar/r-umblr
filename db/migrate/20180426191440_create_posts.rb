class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :post_title
      t.string :post_caption
      t.string :city
      t.string :country
    end 
  end
end
