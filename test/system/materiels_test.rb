require "application_system_test_case"

class MaterielsTest < ApplicationSystemTestCase
  setup do
    @materiel = materiels(:one)
  end

  test "visiting the index" do
    visit materiels_url
    assert_selector "h1", text: "Materiels"
  end

  test "should create materiel" do
    visit materiels_url
    click_on "New materiel"

    fill_in "Assigne a", with: @materiel.assigne_a
    fill_in "Date achat", with: @materiel.date_achat
    fill_in "Expiration garantie", with: @materiel.expiration_garantie
    fill_in "Localisation", with: @materiel.localisation
    fill_in "Marque", with: @materiel.marque
    fill_in "Modele", with: @materiel.modele
    fill_in "Nom", with: @materiel.nom
    fill_in "Notes", with: @materiel.notes
    fill_in "Numero serie", with: @materiel.numero_serie
    fill_in "Statut", with: @materiel.statut
    fill_in "Type materiel", with: @materiel.type_materiel
    click_on "Create Materiel"

    assert_text "Materiel was successfully created"
    click_on "Back"
  end

  test "should update Materiel" do
    visit materiel_url(@materiel)
    click_on "Edit this materiel", match: :first

    fill_in "Assigne a", with: @materiel.assigne_a
    fill_in "Date achat", with: @materiel.date_achat
    fill_in "Expiration garantie", with: @materiel.expiration_garantie
    fill_in "Localisation", with: @materiel.localisation
    fill_in "Marque", with: @materiel.marque
    fill_in "Modele", with: @materiel.modele
    fill_in "Nom", with: @materiel.nom
    fill_in "Notes", with: @materiel.notes
    fill_in "Numero serie", with: @materiel.numero_serie
    fill_in "Statut", with: @materiel.statut
    fill_in "Type materiel", with: @materiel.type_materiel
    click_on "Update Materiel"

    assert_text "Materiel was successfully updated"
    click_on "Back"
  end

  test "should destroy Materiel" do
    visit materiel_url(@materiel)
    click_on "Destroy this materiel", match: :first

    assert_text "Materiel was successfully destroyed"
  end
end
