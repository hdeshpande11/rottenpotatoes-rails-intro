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
    redirect = false
    
    logger.debug(session.inspect)
    

      @highlight = params[:sort_by]
     session[:sort_by] = @highlight
   
    
    if params[:ratings]
       @ratings_fromsort = params[:ratings] 
       session[:ratings] = @ratings_fromsort
    end
  
    
    if !@ratings_fromsort
       @ratings_fromsort = Hash.new
       @ratings_fromsort.each{|elem| @ratings_fromsort.store(elem,1)}
    end
    
    if redirect
      flash.keep
      redirect_to movies_path, :sortby => @highlight, :ratings => @ratings_fromsort
    end
   
   if params[:ratings]
     @movies = Movie.with_ratings(@ratings_fromsort).order(params[:sort_by]).uniq
   else
     @movies = Movie.all.order(params[:sort_by]).uniq
   end
   
   
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
