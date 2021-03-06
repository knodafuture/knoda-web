class Admin::TestDataController < Admin::AdminController
  attr_accessor :mins, :amount, :yesno, :prediction_id
  def create_prediction
    randyBacon = 0
    x = prediction_params
    y = my_params
    @arr = Array.new
    amount = y[:amount]
    amount = amount.to_i
    if y[:username] == ""
      setUser = true
    else
      setUser = false
      x[:user] = User.where("username like ?", "%#{y[:username]}%").first
    end
    amount.times do |p|
      #USER
      if setUser
        u = User.order('random() desc').first
        x[:user] = u
      end

      #CATEGORY
      cat = ['SPORTS']

      x[:tags] = cat

      #IPSUM
      randyBacon = rand(4)
      case randyBacon
        when 0
          body = JSON.load(open("http://www.savageipsum.com/api"))['text']
        when 1
          body = JSON.load(open("http://baconipsum.com/api/?type=all-meat&sentences=1"))[0]
        when 2
          body = JSON.load(open("http://skateipsum.com/get/1/0/JSON"))[0]
          body = body[0..100]
        when 3
          body = JSON.load(open("http://hipsterjesus.com/api/?type=hipster-centric&paras=1&html=false"))['text']
          body = body[0..100]
      end

      x[:body] = body

      #TIME
      startTime = Time.now
      endTime = Time.now.advance(:minutes => y[:mins].to_i)
      expires = Time.at((endTime.to_f - startTime.to_f)*rand + startTime.to_f)

      x[:resolution_date] = expires
      x[:expires_at] = expires
      puts x
      p = Prediction.create(x)
      @arr << p.id

    end
    render "admin/home/index"
    puts "The ids:"
    puts @arr
  end


  def create_votes

    t = vote_params
    v = my_params
    puts 'VOTE PARAMS:'
    puts t
    amount = v[:amount].to_i
    yesno = v[:yesno].to_s

    amount.times do |f|
      if yesno == ""
        random_bool = [true, false].sample
        t[:agree] = random_bool
      elsif yesno == "agree"
        t[:agree] = true
      elsif yesno == "disagree"
        t[:agree] = falsed
      else
        t[:agree] = false
      end
      #USER
      prediction = Prediction.find(t['prediction_id'])
      u = User.order('random() desc').first
      while u.challenges.where(prediction: prediction).first == true
        u = User.order('random() desc').first
      end
      t[:user] = u
      #CREATECHALLENGE
      f = Challenge.create(t)
    end
    redirect_to "/admin"
  end


  def create_comments
    x = comment_params
    y = my_params
    require 'open-uri'
    amount = y[:amount].to_i

    amount.times do |c|
      time = Time.now
      #USER
      u = User.order('random() desc').first
      x[:user] = u

      #IPSUM
      randyBacon = rand(4)
      case randyBacon
        when 0
          body = JSON.load(open("http://www.savageipsum.com/api"))['text']
        when 1
          body = JSON.load(open("http://baconipsum.com/api/?type=all-meat&sentences=1"))[0]
        when 2
          body = JSON.load(open("http://skateipsum.com/get/1/0/JSON"))[0]
          body = body[0..100]
        when 3
          body = JSON.load(open("http://hipsterjesus.com/api/?type=hipster-centric&paras=1&html=false"))['text']
          body = body[0..100]
      end
      x[:text] = body
      #CREATE COMMENT
      c = Comment.create(x)
    end
    redirect_to "/admin"
  end




  private
    def prediction_params
      params.permit(:body, :user, :expires_at, :tags, :resolution_date)
    end

    def vote_params
      params.permit(:user, :prediction_id, :agree)
    end

    def my_params
      params.permit(:mins, :amount, :yesno, :username)
    end

    def comment_params
      params.permit(:user, :prediction_id, :text)
    end

    def search_param
      params.permit(:searchinput)
    end

end
