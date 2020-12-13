class Search < ApplicationRecord
  validates :author, presence: true, unless: :title
  validates :title,  presence: true, unless: :author
  validates :title,  uniqueness: { scope: :author, message: "Title/author pairing already exists" }

  before_validation :format_title
  before_validation :format_author
  before_save       :set_refresh_date

  private

  def set_refresh_date
    self.refreshed_at = Time.now.utc
  end

  def format_title
    self.title = formatter(self.title)
  end

  def format_author
    self.author = formatter(self.author)
  end

  def formatter(value)
    value.downcase.gsub(/\W+/, " ").split(" ").sort.join(" ") if value
  end
end
