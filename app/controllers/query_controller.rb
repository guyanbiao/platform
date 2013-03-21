#encoding: utf-8
class QueryController < ApplicationController
  def index
    case params[:word]
    when 'neal'
      result = {result: ['纪玉瑄', '谷燕彪']}
    when 'go'
      result = {result: ['走', '开始']}
    when 'ahead'
      result = {result: ['一个头', '向前']}
    end
    render json: result
  end
end
