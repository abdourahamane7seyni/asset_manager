json.extract! materiel, :id, :nom, :type_materiel, :marque, :modele, :numero_serie, :statut, :date_achat, :expiration_garantie, :assigne_a, :localisation, :notes, :created_at, :updated_at
json.url materiel_url(materiel, format: :json)
