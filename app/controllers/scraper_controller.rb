class ScraperController < ApplicationController
  def scrape
    # Url du site a scraper
    url1 = "https://info.agriculture.gouv.fr/gedei/site/bo-agri/supima/7d1e4444-1888-4a06-9429-b5913a000b49"
    url2 = "https://info.agriculture.gouv.fr/gedei/site/bo-agri/supima/ee1a7036-8ac6-4cc9-ad5a-f203359dd9d8"

    if url1.present?
      result1 = perform_scraping(url1)
      result2 = perform_scraping(url2)
      result = { denrees: result1, alertes_urgences: result2 }
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
    content_page = doc.css("div.container")
    all_categories = content_page.css("div.menu-gauche-supima").css("ul > ul")
    # fetch_all categories
    sub_categories = all_categories.css("ul > ul").css("li").map { |element| element.text }
    { sous_category: sub_categories }
  end
end
