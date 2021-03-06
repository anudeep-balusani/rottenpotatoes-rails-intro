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
    @movies = Movie.all

    #Begin Part 2
    @all_ratings = Movie.ratings_list

    #Start with all checked 
    @checked_ratings = @all_ratings

    if params[:ratings]
	    #current session keys
	    @checked_ratings = (params[:ratings]).keys
            #Begin Part 3 (Addition)
    else
	    if session[:ratings]
		    #sustaining older session keys
		    @checked_ratings = session[:ratings]
	    else
		    #defaul => all checked
		    @checked_ratings = @all_ratings
	    end

    end

    if @checked_ratings != session[:ratings]
	    #consistency 
	    session[:ratings] = @checked_ratings
    end
            #End Part 3 (Addition)

    @movies = @movies.where('rating in (?)', @checked_ratings)
    #End Part 2

    #Begin Part 1
    if params[:sort_by]
	    @sorting = params[:sort_by]
    else
	    @sorting = session[:sort_by]
    end

          # Begin Part 3(Addition)
    if @sorting != session[:sort_by]
	    session[:sort_by] = @sorting 
    end
          #End Part 3 (Addition)
    if @sorting == 'title'
	    @movies = @movies.order(@sorting)
	    @title_header = 'hilite'
    elsif @sorting == 'release_date'
	    @movies = @movies.order(@sorting)
	    @release_header = 'hilite'
    end

    #End Part 1
    
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
