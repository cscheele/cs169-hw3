class MoviesController < ApplicationController

  @@sort = nil
  @sort = nil
  @@all_ratings = Movie.order('rating').distinct.pluck(:rating)
  @all_ratings = nil
  @selected_ratings = nil

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    home
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def sort
    @@sort = params[:type]
    home
    render :index
  end


  def home
    if params[:ratings] == nil
      @selected_ratings = (session[:selected_ratings] || @@all_ratings)
    else 
      @selected_ratings = params[:ratings].keys
    end
    if @@sort
      @movies = Movie.order(@@sort).where({ rating: @selected_ratings})
    else
      @movies = Movie.where({ rating: @selected_ratings})
    end
    @sort = @@sort
    @all_ratings = @@all_ratings
    session[:selected_ratings] = @selected_ratings
  end
end
