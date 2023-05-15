class ClientsController < ApplicationController    

    def register
        @client = Client.new
    end

    def create
        @client = Client.new(client_account_params)   

        if @client.save
            redirect_to clients_login_path       
        else
            render :register, status: :unprocessable_entity
        end
    end

    def login_submit  
        if @client = Client.authenticate(params[:email], params[:password])
            session[:client_token] = @client.token
            redirect_to clients_dashboard_path(@client)
        else
            redirect_to clients_login_path
        end   
    end

    def dashboard
        @client = current_client
        @performer = Performer.all

    end

    def show
        @performer = Performer.find(params[:id])
        
    end

    def logout
        session.delete(:client_token)
        redirect_to users_home_path
    end

    private
    def client_account_params
        params.require(:client).permit(:email, :password, :password_confirmation)
    end

    def current_client
        if session[:client_token]
          @current_client ||= Client.find_by(token: session[:client_token])
        end
    end


end