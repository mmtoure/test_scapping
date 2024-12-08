# lib/tasks/craping_task.rake

desc "Print something five times."
namespace :command do
  task scraping: :environment do
  url1 = "https://info.agriculture.gouv.fr/gedei/site/bo-agri/supima/7d1e4444-1888-4a06-9429-b5913a000b49"
  url2 = "https://info.agriculture.gouv.fr/gedei/site/bo-agri/supima/ee1a7036-8ac6-4cc9-ad5a-f203359dd9d8"
  if url1.present?

    perform_scraping(url1)
    perform_scraping(url2)
  end
end

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
  category = doc.css("div.content-supima").css("h3").text
  category = Category.find_or_create_by(name: category)

  en_vigueur=doc.css("ul#liste-resultat").css("li").css("span.badge-EnVigueur > a > span", "span.badge-Abrogee > a > span").map { |node| node.text.strip }
  methode=doc.css("ul#liste-resultat").css("li").css("span.badge-ordre-methode > a > span").map { |node| node.text.strip }
  date_pulication=doc.css("ul#liste-resultat").css("li").css("div.span3 > span").map { |node| node.text.strip.split " " }
  contenu=doc.css("ul#liste-resultat").css("li").css("p").map { |node| node.text.strip }

  # Construction d'un objet JSON pour les publications
  json_object = en_vigueur.zip(methode, contenu, date_pulication).map do |en_vigueur, methode, contenu, date_publication|
    article = Article.new(en_vigueur: en_vigueur, methode: methode, contenu: contenu, date_publication: date_publication.last.to_datetime, category: category)
    article.save!
  end

  # articles.push(en_vigueur: en_vigueur, methode: methode, date_publication: date_pulication, contenu: contenu)
  list = { sub_categories: sub_categories, articles: json_object }
  # Print items
  list
end
end
