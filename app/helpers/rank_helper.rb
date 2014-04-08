module RankHelper
  def transform_logo(url)
    url.gsub(/w=\d+&h=\d+/, 'w=20&h=20')
  end
end
