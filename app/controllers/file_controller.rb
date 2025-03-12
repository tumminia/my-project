require "sqlite3"
require "json"

class FileController < ApplicationController
  def index
    cookies[:user] = { value: "RubyOnRails", expires: 3.days.from_now }
  end

  def sqlite3
    db_path = Rails.root.join("db", "giacenza.db").to_s
    db = SQLite3::Database.new(db_path)
    db.results_as_hash = true

    @frigorifero = db.execute("SELECT * FROM frigorifero")

    db.close

     Rails.logger.info "📢 Dati dal database: #{@frigorifero.inspect}"
  end

  def piatti
    db_path = Rails.root.join("db", "giacenza.db").to_s
    db = SQLite3::Database.new(db_path)
    db.results_as_hash = true

    @piatti = db.execute("SELECT * FROM piatti")

    db.close
    render json: @piatti
  end

  def disponibile
    db_path = Rails.root.join("db", "giacenza.db").to_s
    db = SQLite3::Database.new(db_path)
    db.results_as_hash = true

    posti = params[:posti] || 2
    giorno = params[:giorno] || "2025-03-11"
    orario = params[:orario] || "12:00"

    @tavolo = db.execute("SELECT posti,giorno,orario,COUNT(posti) AS prenotati FROM tavolo
    WHERE posti=? AND giorno=? AND orario=?",
    [ posti, giorno, orario ])

    db.close
    render json: @tavolo
  end

  def mex
    db_path = Rails.root.join("db", "giacenza.db").to_s
    db = SQLite3::Database.new(db_path)
    db.results_as_hash = true

    token = params[:token]
    nome = params[:nome]
    numero = params[:numero]
    posti = params[:posti] || 2
    giorno = params[:giorno] || "2025-03-11"
    orario = params[:orario] || "12:00"

    if token==cookies[:'XSRF-TOKEN']
      @messaggio = [ { "mex"=>"tavolo prenotato a nome: #{nome}", "token": "#{token}" } ]
    else
      @messaggio = [ { "mex"=>" token differente:", "token": "#{token}" } ]
    end

    @tavolo = db.execute("INSERT INTO tavolo (nome, numero, posti, giorno, orario)
     VALUES
     (?,?,?,?,?)",
    [ nome, numero, posti, giorno, orario ])


    db.close

    # puts token
    # redirect_to "/mex"
    render json: @messaggio
  end

  def name
    name = params[:name] || "Guest"
    render plain: "Hello, #{name}"
  end
end
