require "pg"

class Query
    def initialize(query)
      @query = query.capitalize
    end

    def xml
      conn = PG.connect(
    dbname: "ristorante",
    user: "postgres",
    password: "password",
    host: "localhost",
    port: 5432)




    result = conn.exec("#{@query}")

    File.open("frigorifero.xml", "a") do |file|
      file.puts '<?xml version="1.0" encoding="UTF-8"?>'
      file.puts "<rows>"
      result.each do |row|
        file.puts "<row>"
        file.puts '<ingrediente name="ingrediente">' + row["ingrediente"] + "</ingrediente>"
        file.puts '<quantita name="quantita">' + row["quantita"] + "</quantita>"
        file.puts '<giacenza name="giacenza">' + row["giacenza"] + "</giacenza>"
        file.puts "</row>"
      end
      file.puts "</rows>"
    end


    conn.close
    end
end

object = Query.new("SELECT * FROM frigorifero")
object.xml
