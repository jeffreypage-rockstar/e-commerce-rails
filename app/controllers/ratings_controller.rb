class RatingsController < ApplicationController
	def update
	if(params[:id].to_s != "0")
    	#@rating = Rating.find(params[:id])
      session[:rating] = {:rating_id => params[:id], :user_id => current_user.id, :designer_id => params[:designer_id], :score => params[:score]}
    else
      #@designer = User.find(params[:designer_id])
    	#@rating = Rating.new(:user_id => current_user.id, :designer_id => params[:designer_id])
      session[:rating] = {:rating_id => 0, :user_id => current_user.id, :designer_id => params[:designer_id], :score => params[:score]}
   	end
    puts "session ="+session[:rating].inspect
    #if @rating.update_attributes(score: params[:score])
      render :partial => 'designer_data'
     
    #end
  end
  def update_ratings
    puts "adsfasdfasdfasd="+session[:rating].inspect
    if(session[:rating] != nil)
      @id = session[:rating][:rating_id]
      @user_id = session[:rating][:user_id]
      @designer_id = session[:rating][:designer_id]
      @score = session[:rating][:score]
      if(@id.to_s != "0")
        @rating = Rating.find(@id)
      else
        @rating = Rating.new(:user_id => @user_id, :designer_id => @designer_id)
      end
      if @rating.update_attributes(score: @score)
         @ratings = Rating.where('designer_id = ?',@designer_id)
    if @ratings == []
      @avg_rating = 0
      @count = 0
      #@rating = Rating.new(:id => 0,:score => 0, :designer_id => @designer.id)
    else
      @count = Rating.where('designer_id = ?',@designer_id).count.to_s
      @avg_rating = Rating.where('designer_id = ?',@designer_id).sum(:score).to_f/@count.to_f
      
    end
    session[:rating]=nil
        render :partial => 'designer_data'
        
      end
    end
  end
end
