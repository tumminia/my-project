require "sqlite3"
require "json"
require "securerandom"

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

    # Rails.logger.info "📢 Dati dal database: #{@frigorifero.inspect}"
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

    id = SecureRandom.alphanumeric(10)
    token = params[:token] || 1234
    nome = params[:nome]
    numero = params[:numero]
    posti = params[:posti] || 2
    giorno = params[:giorno] || "2025-03-16"
    orario = params[:orario] || "22:00"
    mex = ""

    x = controllo(posti, giorno, orario).to_i

    if x<3
      @tavolo = db.execute("INSERT INTO tavolo (id, nome, numero, posti, giorno, orario)
      VALUES (?,?,?,?,?,?)",
      [ id, nome, numero, posti, giorno, orario ])

      mex = "tavolo prenotato a nome: #{nome}"
    else
      mex = "tavolo da #{posti} posti per il giorno #{giorno} e orario #{orario} non sono disponibili: #{x}"
    end

    @messaggio = [ { "mex"=>mex, "token": "#{token}" } ]

    db.close

    # puts token
    # redirect_to "/mex"
    render json: @messaggio
  end

  def controllo(w, x, y)
    db_path  = Rails.root.join("db", "giacenza.db").to_s
    db = SQLite3::Database.new(db_path)
    db.results_as_hash = true

    @value = db.execute("SELECT COUNT(posti) as prenotati FROM tavolo
     WHERE posti=? AND giorno=? AND orario=?",
     [ w, x, y ])

     @value.each do |row|
      x = row["prenotati"]
      puts "Valore: #{x}"
     end

     db.close

     x
  end

  def name
    name = params[:name] || "Guest"
    render plain: "Hello, #{name}"
  end
end
