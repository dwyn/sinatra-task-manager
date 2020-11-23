class ManagerController < ApplicationController


    get '/managers' do
        if logged_in?
            @managers = Manager.all

            erb :'managers/managers'
        else
            redirect '/managers/login'
        end
    end

    get '/managers/signup' do
        erb :'managers/create_manager'
    end

    post '/managers/signup' do
        @manager = Manager.new(params["manager"])
        if @manager.save
            redirect "/managers/#{@manager.slug}"
        else
            redirect '/managers/signup'
        end
        # binding.pry
    end

    get '/managers/login' do
        erb :'managers/login'
    end

    post '/managers/login' do
        @manager = Manager.find_by(email: params["manager"]["email"])
        if @manager && @manager.authenticate(params["manager"]["password"])
            session[:manager_id] = @manager.id
            redirect '/managers'
        else
            redirect '/managers/login'
        end
    end

    get '/managers/logout' do
        if logged_in?
            session.destroy
            redirect '/managers/login'
        # else
        #     redirect '/'
        end
    end

    get '/managers/:slug' do
        if logged_in?
            @manager = Manager.find_by_slug(params[:slug])
        # binding.pry
            erb :'managers/show_manager'
        else
            redirect '/managers/login'
        end
    end


    helpers do

        def logged_in?
            !!current_user
        end

        def current_user
            @current_user ||= Manager.find_by(id: session[:manager_id]) if session[:manager_id]
        end

    end

end