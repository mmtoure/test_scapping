class ScraperController < ApplicationController
  def scrape
    # Url du site a scraper
    url = "https://info.agriculture.gouv.fr/gedei/site/bo-agri/supima/7d1e4444-1888-4a06-9429-b5913a000b49"

    if url.present?
      result = perform_scraping(url)
      render json: result, status: :ok
    else
      render json: { error: "URL is required" }, status: :bad_request
    end
  end

  private
  # Méthode principale qui effectue le scraping.
  def perform_scraping(url)
    # Effectue une requête HTTP GET pour récupérer le contenu de la page.
    response = HTTParty.get(url)

    # Vérifie si la requête HTTP a réussi (code 200).
    if response.code == 200
      parse_html(response.body)
    else
      { error: "Failed to fetch URL", status: response.code }
    end
  end

  # Méthode privée pour analyser le HTML et extraire les informations nécessaires.
  def parse_html(html)
    # Utilise Nokogiri pour analyser le contenu HTML de la page.
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
