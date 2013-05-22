module ThemesHelper
  def short_link
    short = self.split("/").last(2).join
  end
end
