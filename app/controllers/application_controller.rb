# coding: utf-8
class ApplicationController < ActionController::Base
  require 'open-uri'
  require 'json'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_tenses

  include Download

  def validate_verbs_list(str)
    @str = str.gsub(/[[:space:]]/,'')
    if @str.length != 0
      if @str =~ /^[A-Za-zêéèùîôàçï]{3,}(\,{1}\w{3,})*$/u
        return @str.split(',')
      else
        return 0
      end
    else
      return ''
    end
  end

  def validate_form(form)
    if form =~ /^[\w\s]+$/u || form.trim == "-"
      return 1
    else
      return 0
    end
  end


  def require_admin
    unless current_user && current_user.role == 'admin'
      flash[:error] = "You are not an admin"
      redirect_to root_path
    end
  end

  def transl_count
    if current_user && current_user.role == 'admin'
      @translation = Translation.all
    end
  end

  def set_tenses
    @tenses = [:présent, :passé_composé, :imparfait, :plus_que_parfait,
      :passé_simple, :passé_antérieur, :futur_simple, :futur_antérieur,:subjonctif_présent,
      :subjonctif_passé,:subjonctif_imparfait, :subjonctif_plus_que_parfait, :conditionnel_présent, :conditionnel_passé_première, :conditionnel_passé_deuxième]
    @forms = [:je, :tu, :il, :nous, :vous, :ils]
  end

end
