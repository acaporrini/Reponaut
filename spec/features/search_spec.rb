require 'spec_helper'

RSpec.describe 'User search for repos' do
  before do
    visit '/repos/search'
    fill_in 'term', with: 'test'
    find('input[type="submit"]').click
  end

  it 'renders the repos names', :vcr do
    expect(page).to have_content('testing-samples')
  end

  it 'searches in description', :vcr do
    select 'Description', from: 'search_in'
    find('input[type="submit"]').click
    expect(page).to have_content('jest')
  end

  it 'navigates to the second page', :vcr do
    find('.pagy-nav').find('.next').find('a').click
    expect(page).to have_content('Testnet3-Challenges')
  end
end
