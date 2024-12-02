class ScraperController < ApplicationController
  def scrape
    url = "https://info.agriculture.gouv.fr/gedei/site/bo-agri/supima/7d1e4444-1888-4a06-9429-b5913a000b49"

    if url.present?
      result = perform_scraping(url)
      render json: result, status: :ok
    else
      render json: { error: "URL is required" }, status: :bad_request
    end
  end

  private

  def perform_scraping(url)
    response = HTTParty.get(url)

    if response.code == 200
      parse_html(response.body)
    else
      { error: "Failed to fetch URL", status: response.code }
    end
  end

  def parse_html(html)
    doc = Nokogiri::HTML(html)
    # Get container
    links = doc.css("div.container")
    all_categories = links.css("div.menu-gauche-supima").css("ul")
    # fetch_all categories
    titles = all_categories.css("ul").css("li").map { |element| element.text }
    { categories: titles }

    # fetch sub_categories
  end
end
