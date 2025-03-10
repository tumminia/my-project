require "sqlite3"
require "json"

class FileController < ApplicationController
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
end
