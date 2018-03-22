class BtcJpy < ApplicationRecord
  def previous
    BtcJpy.where("id < ?", self.id).order("id DESC").first
  end
 
  def next
    BtcJpy.where("id > ?", self.id).order("id ASC").first
  end
end
