class ImagesController < ApplicationController
  before_action :image_params, only: [:create]
  def create
    analysis_session_token = current_visit.visitor_token
    path_to_rails = Rails.root.to_s.split('/')
    path_to_rails.pop
    image = Image.create(image_params)
    image.update(analyzing: true)
    image.captured_image.variant(resize_to_limit: [800, 800]).processed
    path_to_python =  "#{path_to_rails.join('/')}/models/research/object_detection"
    path_to_test_images = "#{path_to_python}/test_images"
    absolute_path_to_file = ActiveStorage::Blob.service.path_for(image.captured_image.variant(resize_to_limit: [800, 800]).key)
    file_name = "#{analysis_session_token}.#{image.captured_image.filename.extension_without_delimiter}"
    full_path_to_uploaded_image = "#{path_to_test_images}/#{file_name}"
    system("cp #{absolute_path_to_file} #{full_path_to_uploaded_image}")
    system("cd #{path_to_python} ; python run.py #{file_name}")
    image.update(analyzing: false, analysis_completed: true)
    analyzed_file_name = "#{file_name}.png"
    path_to_analyzed_image = "#{path_to_python}/outputs/#{analyzed_file_name}"
    if File.file?(path_to_analyzed_image)
      image.update(assertion: 'created')
      @analyzed_image = ImageAnalysis.new(image_id: image.id)
      @analyzed_image.analyzed_image.attach(io: File.open(path_to_analyzed_image), filename: analyzed_file_name)
      @analyzed_image.save
    else
      image.update(assertion: 'failed')
    end
    system("rm #{path_to_test_images}/#{file_name}")
  end

  def new
    @image = Image.new
  end

  def index
  end

  private 
  def image_params
    if !params[:image]
      redirect_to root_path
      flash[:error] = "please upload an image first"
      return
    end
    params.require(:image).permit(:captured_image)
  end
end
