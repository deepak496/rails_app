EScout::Application.routes.draw do

  match '/products/:product_slug', :to => 'cms/content#show', :defaults => { :path => 'product-details' }

  match '/cms/prototypes/import', :to => 'cms/products#import'

  match '/cms/prototypes/sort', :to => 'cms/prototypes#sort'
  match '/external', :to => 'external_api#retrieve', :as => 'external_api'
  namespace :cms do
    content_blocks :products
    content_blocks :banners
    resources :prototypes
    resources :properties
  end

  devise_for :members, ActiveAdmin::Devise.config

  mount BcmsPagetext::Engine => '/bcms_pagetext'
  mount BcmsSuperuser::Engine => '/bcms_superuser'
  mount BcmsCarrierwave::Engine => '/bcms_carrierwave'
  mount BcmsCkbrowser::Engine => '/bcms_ckbrowser'

  ActiveAdmin.routes(self)
  CarrierWave::Mogilefs::Mvi.routes(self)


  root :to => 'home#index'
  resources :news, :only => [:index] do
    member do
      get 'image'
    end
  end
  resources :events do
    resources :event_enrolments, :path => 'enrolments', :except => [:show]
    resources :event_files, :path => 'files', :only => [:new, :create, :destroy]
    member do
      get 'oversee' # manage is reserved by cancan :/
      post 'enrol'
    end

    collection do
      get 'data'
    end
  end

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'

  match '/aopg-guide/chapter-1/joey-scouts',        :to => 'pages#aopg_chapter_1_2', :as => :aopg_joey_scouts
  match '/aopg-guide/chapter-1/cub-scouts',         :to => 'pages#aopg_chapter_1_3', :as => :aopg_cub_scouts
  match '/aopg-guide/chapter-1/scouts',             :to => 'pages#aopg_chapter_1_4', :as => :aopg_scouts
  match '/aopg-guide/chapter-1/venturer-scouts',    :to => 'pages#aopg_chapter_1_5', :as => :aopg_venturer_scouts
  match '/aopg-guide/chapter-1/rover-scouts',       :to => 'pages#aopg_chapter_1_6', :as => :aopg_rover_scouts

  match '/award_scheme',             :to => 'badges#index'
  match '/award_scheme/section/:id', :to => 'badges#section'

  match '/programs/list', :to => 'programs#list'
  match '/login', :to => 'pages#login'
  match '/launch', :to => 'pages#central_launch_page'
  match '/moderation', :to => 'pages#central_moderation_page'

  resources :programs do
    member do
      post 'rate'
      post 'favourite'
      post 'un_favourite'
      get 'details'
      get 'schedule'
      get 'print'
    end
    collection do
      get 'available_items'
    end
  end
  resources :badges
  resources :comments
  resources :activities do
    member do
      post 'rate'
      post 'favourite'
      post 'un_favourite'
    end
  end
  resources :scheduled_programs do
    member do
      get 'print'
    end
  end
  resources :submit_program do
    member do
      post :add_resource
    end
  end
  resources :object_resources do
    get :autocomplete_activity_name, :on => :collection
    get :autocomplete_badge_name, :on => :collection
    get :autocomplete_program_name, :on => :collection
    get :autocomplete_register_history_patrol, :on => :collection
  end
  resources :formations do
    resources :register_meetings, :shallow => true
  end

  resources :register_meetings do
    resource :register_completion
  end

  resources :register_history do
    collection do
      post 'save_history'
      post 'mark_attendance'
      get 'attendance_pagination'
      post 'camp'
      post 'excursion'
      get 'formation_member_sheet'
      post 'badge_topic'
    end
  end
  match '/mobile', :to => 'mobile#index', :as => :mobile_home
  match '/mobile/about(/:page)', :to => 'mobile#about', :as => :mobile_about
  match '/mobile/join(/:section)', :to => 'mobile#join', :as => :mobile_join
  match '/mobile/awards', :to => 'mobile#award_sections', :as => :mobile_award_sections
  match '/mobile/awards/:section', :to => 'mobile#award_badge_groups', :as => :mobile_award_badge_groups
  match '/mobile/awards/:section/:group', :to => 'mobile#award_badges', :as => :mobile_award_badges
  match '/mobile/awards/:section/:group/:badge', :to => 'mobile#award_badge', :as => :mobile_award_badge
  match '/mobile/news', :to => 'mobile#news', :as => :mobile_news
  match '/mobile/newsFeed', :to => 'mobile#newsFeed'
  match '/mobile/videos', :to => 'mobile#videos', :as => :mobile_videos
  match '/mobile/locator', :to => 'mobile#locator', :as => :mobile_locator
  match '/mobile/locator/search', :to => 'mobile#locator_search', :as => :mobile_locator_search
  match '/mobile/settings', :to => 'mobile#settings', :as => :mobile_settings
  match '/mobile/auth', :to => 'mobile#auth', :as => :mobile_auth
  match '/mobile/auth/attempt', :to => 'mobile#auth_attempt'
  match '/mobile/check', :to => 'mobile#check'

  match '/cas_api/member_details' => 'cas_api#member_details'

  match '/banners', :to => 'banners#index'

  match '/feeds/news/:branch', :to => 'feeds#news', :as => :news_feeds, :defaults => { :format => :rss }
  match '/feeds/mobile_news/:branch', :to => 'feeds#mobile_news'

  match '/profile', :to => 'members#profile', :as => :member_profile
  match '/update_profile', :to => 'members#update_profile', :as => :member_update_profile

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  mount_browsercms
end
