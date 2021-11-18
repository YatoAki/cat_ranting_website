class CatRentalRequestsController < ApplicationController

    def approve
        current_cat_rental_request.approve!
        redirect_to cat_url(current_cat_rental_request.cat)
    end

    def deny
        current_cat_rental_request.deny!
        redirect_to cat_url(current_cat_rental_request.cat)
    end

    def new
        render :new
    end
    
    
    def create
        @cat_rental_request = CatRentalRequest.new(safe_params)
        if @cat_rental_request.save
            redirect_to cat_url(@cat_rental_request.cat)
        else  
            render :new
        end
    end 

    private 

    def current_cat_rental_request
        @cat_rental_request ||=
          CatRentalRequest.includes(:cat).find(params[:id])
    end

    def safe_params
        params.require(:cat_rental_request)
        .permit(:cat_id,:start_date,:end_date,:status)
    end
end