require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end
    it 'should return the result to Movies' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end
  end
  
  describe 'the movies are showed' do
    it 'Movie.find should be used' do
      expect(Movie).to receive(:find).with("2")
      get :show, {:id => "2"}
    end
    it 'the show template for rendering should be selected' do
      allow(Movie).to receive(:find)
      get :show, {:id => "5"}
      expect(response).to render_template('show')
    end
  end
  
  describe 'adding movies from TMDb to existing Movie' do
    it 'Movie.create_from_tmdb should not be called if no checkbox is checked' do
      expect(Movie).not_to receive(:create_from_tmdb)
      post :add_tmdb, {:tmdb_movies => nil}
    end
    it 'Movie.create_from_tmdb should be called if checkbox is checked' do
      expect(Movie).to receive(:create_from_tmdb).with("315")
      post :add_tmdb, {:tmdb_movies => {"315": "1"}}
    end
  end
  
  describe 'sort the moveis in the index' do
    it 'should sort the movies according to release date' do
      get :index, :sort => 'release_date'
      expect(controller.params[:sort]).to eq('release_date')
    end
  end
end
