module Endpoints
  class Fragments < Grape::API

    get 'fragments', jbuilder: 'fragments' do
      @fragments = Fragment.all
    end

    get 'fragments/:id' do
        @fragments = Fragment.find(params[:id])
    end

    get 'profile' do
      fragment = Fragment.where(user_id: '28').last
      url = fragment.url
      url = URI.parse(url)
      respond = CGI.parse(url.query)
      video_id = respond['v'].first

      @video_from_cloud = Cloudinary::Api.resources_by_ids(video_id, :resource_type => :video)
      # cloud = video_from_cloud
      # fragment.cloud_url = cloud['resources'].last['url']
      # fragmen.save
    end


    params do
      requires :url, type: String, desc: 'URL'
      optional :start, type: Integer, desc: 'start'
      optional :end, type: Integer, desc: 'end'
    end

    post 'fragments/embed_url' do
      @start = params[:start]
      @end = params[:end]
      url = URI.parse(params[:url])
      respond = CGI.parse(url.query)
      video_id = respond['v'].first
      embed = "https://www.youtube.com/embed/#{video_id}?start=#{@start}&end=#{@end}&autoplay=1"
    end

    params do
      requires :url, type: String, desc: 'URL'
      requires :user_id, type: Integer, desc: 'user_id'
      optional :start, type: Integer, desc: 'start'
      optional :end, type: Integer, desc: 'end'
    end

    post 'fragments/create' do
       #begin
        fragment = Fragment.create({
                                  url: params[:url],
                                  user_id: '28',
                                  start: params[:start],
                                  end: params[:end],
                                  status: 'new'
                                  })

      #   if fragment.save
      #     {
      #         status: :success
      #     }
      #   else
      #     error!(
      #         {
      #         status: :error, message: fragment.errors.full_messages.first
      #         }) if fragment.errors
      #   end
      # rescue ActiveRecord::RecordNotFound
      #   error!({status: :error, message: :not_found}, 404)
      # end

    end

    params do
      optional :name, type: String, desc: 'name'
      optional :cloud_url, type: String, desc: 'cloud_url'
    end

    post 'fragments/:id' do
      begin
        fragment = Fragment.find(params[:id])
        fragment.name = params[:name]
        fragment.cloud_url = params[:cloud_url]
        if fragment.save
          {
              status: :success
          }
          else
          error!({status: :error, message: fragment.errors.full_messages.first}) if fragment.errors.any?
        end


      rescue ActiveRecord::RecordNotFound
        error!({status: :error, message: :not_found}, 404)
      end
    end

    params do
      requires :id, type: Integer, desc: 'id'
    end

    delete 'fragments/delete/:id' do
      begin
        fragment = Fragment.find(params[:id])
        {
            status: :success
        } if fragment.delete
      rescue ActiveRecord::RecordNotFound
        error!({status: :error, message: :not_found}, 404)
      end
    end

    # params do
    #   requires :user_id, type: Integer, desc: 'user_id'
    # end
    #
    # delete 'fragments/delete_all' do
    #   fragment = Fragment.where(user_id: params[:user_id]).delete
    # end

    params do
      requires :user_id, type: Integer, desc: 'user_id'
    end

    post 'download' do
      fragment = Fragment.where(user_id: params[:user_id]).last
      job_id = DownloadWorker.perform_async(fragment.id)
    end
    #
    params do
      requires :url, type: String, desc: 'url'
    end

    post 'fragments/video/info' do
      url = params[:url]
      url = URI.parse(url)
      respond = CGI.parse(url.query)
      video_id = respond['v'].first

        @video = Yt::Video.new id: video_id
       [id: @video.id,
        title: @video.title,
        description: @video.description,
        published_at: @video.published_at,
        thumbnail_url: @video.thumbnail_url,
        channel_id: @video.channel_id,
        channel_title: @video.channel_title,
        category_id: @video.category_id,
        category_title: @video.category_title,
        length: @video.length].first
    end

    params do
      requires :user_id, type: String, desc: 'user_id'
    end

    post 'cloudinary' do
      fragment = Fragment.where(user_id: params[:user_id]).last
      # url = fragment.url
      # url = URI.parse(url)
      # respond = CGI.parse(url.query)
      # video_id = respond['v'].first
      # video = Cloudinary::Api.resource(video_id, :resource_type => :video)
      job_id = CloudinaryWorker.perform_async(fragment.id)
      stats = Sidekiq::Status::get_all job_id
      stats['status']
      #worker = all_stats["worker"]
      #args = all_stats["args"]
      #update_time = all_stats["update_time"]
      #jid = all_stats["jid"]



    end

    params do
      requires :cloud_uri, type: String, desc: 'URL'
      optional :title, type: String, desc: 'title'
      optional :description, type: String, desc: 'description'
    end

    post 'uploader' do
      #fragment = Fragment.find(params[:id])
      cloud_uri = params[:cloud_uri]
      title = params[:title]
      description = params[:description]
      job_id = UploaderWorker.perform_async(title,description,cloud_uri)
    end

    params do
      requires :job_id, type: String, desc: 'job_id'
    end

    get 'status_job' do
      all_stats = status_job(params[:job_id])
      status = all_stats['status']
      #worker = all_stats["worker"]
      #args = all_stats["args"]
      #update_time = all_stats["update_time"]
      #jid = all_stats["jid"]
    end

  end
end
