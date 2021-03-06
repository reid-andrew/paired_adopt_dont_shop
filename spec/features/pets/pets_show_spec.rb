require 'rails_helper'

RSpec.describe "PETS show page - A user", type: :feature do
  before(:each) do
    @shelter_1 = Shelter.create( name: "Henry Porter's Puppies",
                                address: "1315 Monaco Parkway",
                                city: "Denver",
                                state: "CO",
                                zip: "80220"
                              )
    @pet_1 = Pet.create( name: "Karl Barx",
                        age: 4,
                        sex: "Male",
                        shelter_id: @shelter_1.id,
                        image: 'hp.jpg',
                        adoptable_status: 'Adoptable',
                        description: "He's the cutest!")
    @pet_2 = Pet.create( name: "Liza Bear",
                        age: 16,
                        sex: "Female",
                        shelter_id: @shelter_1.id,
                        image: 'hp2.jpg',
                        adoptable_status: 'Pending Adoption',
                        description: "Newfie drool!")
  end
  it "can see the details of a specific pet" do
    visit "/pets/#{@pet_1[:id]}"

    expect(page).to have_content(@pet_1.name.upcase)
    expect(page).to have_content(@pet_1.description)
    expect(page).to have_content(@pet_1.age)
    expect(page).to have_content(@pet_1.sex)
    expect(page).to have_content(@pet_1.adoptable_status)
    expect(page).to have_css("img[src='/assets/hp-606612a36d3cc16d901e74616fbd73a568030910d171797aa44123d55a9bfa70.jpg']")

    visit "/pets/#{@pet_2[:id]}"

    expect(page).to have_content(@pet_2.name.upcase)
    expect(page).to have_content(@pet_2.description)
    expect(page).to have_content(@pet_2.age)
    expect(page).to have_content(@pet_2.sex)
    expect(page).to have_content(@pet_2.adoptable_status)
    expect(page).to have_css("img[src='/assets/hp2-d54ec5938e641f10459be7bdba8fbb7fed849ec44ba2d1ed8568773d69bd164d.jpg']")
  end

  it "can update a pet" do
    visit "/pets/#{@pet_1[:id]}"
    click_link "Update Pet"

    expect(page).to have_current_path("/pets/#{@pet_1.id}/edit")
    select "Female", :from => "sex"
    fill_in(:description, :with => "You won't find any cuter!")
    fill_in(:image, :with => "hp2.jpg")
    click_button "Update Pet"

    expect(page).to have_current_path("/pets/#{@pet_1[:id]}")
    expect(page).to have_content("Female")
    expect(page).to have_content("You won't find any cuter!")
    expect(page).to have_css("img[src='/assets/hp2-d54ec5938e641f10459be7bdba8fbb7fed849ec44ba2d1ed8568773d69bd164d.jpg']")
  end

  it "can delete a pet" do
    visit "/shelters/#{@shelter_1.id}/pets"

    expect(page).to have_content(@pet_1.name)

    visit "/pets/#{@pet_1[:id]}"
    click_link "Delete Pet"

    expect(page).to have_current_path("/pets")
    expect(page).to_not have_content(@pet_1.name)
  end

  it "can see applications for a pet" do
    application_1 = Application.create( name: "Andy",
                                          address: "123 Main St",
                                          city: "Denver",
                                          state: "CO",
                                          zip: "80220",
                                          phone_number: "123-456-7890",
                                          description: "I can has dogs.")
    pet_application_1 = PetApplication.create(  pet_id: @pet_1.id,
                                                  application_id: application_1.id)

    visit "/pets/#{@pet_1.id}"
    click_link "View All Applications"

    expect(page).to have_current_path("/pets/#{@pet_1.id}/applications")
    expect(page). to have_content(application_1.name)

    click_link "#{application_1.name}"

    expect(page).to have_current_path("/applications/#{application_1.id}")
  end


  it 'will have link to applicant pet is on hold for' do
    application_1 = Application.create( name: "Andy",
                                          address: "123 Main St",
                                          city: "Denver",
                                          state: "CO",
                                          zip: "80220",
                                          phone_number: "123-456-7890",
                                          description: "I can has dogs.")
    pet_application_1 = PetApplication.create(  pet_id: @pet_1.id,
                                        application_id: application_1.id)

    visit "/applications/#{application_1.id}"
    within("##{@pet_1.id}") do
      click_link "Approve application for #{@pet_1.name}"
    end

    visit "/pets/#{@pet_1.id}"
    expect(page).to have_link("#{application_1.name}")
    expect(page).to have_content("On hold for #{application_1.name}")
  end


end
