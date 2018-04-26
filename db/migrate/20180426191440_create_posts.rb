class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :post_title
      t.string :post_image
      t.string :post_caption
    end 
  end
end
