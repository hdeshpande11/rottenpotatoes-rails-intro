class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  

  def index

    @all_ratings = Movie.get_ratings
    @highlight = params[:sort_by]
    @checked_ratings = params[:ratings] || session[:ratings] || {}
    sort_var = params[:sort_by] || session[:sort_by]
 
    if @checked_ratings == {}
      @checked_ratings = Hash[@all_ratings.map {|rating| [rating,rating]}]
    end
 
    if session[:sort_by] != params[:sort_by] or session[:ratings] != params[:ratings]
      session[:sort_by] = sort_var
      session[:ratings] = @checked_ratings
      flash.keep
      return redirect_to :sort_by => sort_var, :ratings => @checked_ratings
    end
    @movies = Movie.all.where(:rating => @checked_ratings.keys).order(params[:sort_by]).uniq
   

########
  
   
   
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

end
