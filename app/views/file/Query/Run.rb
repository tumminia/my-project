require "pg"

class Run
  def initialize(word, uno, due)
    @word = word.capitalize
    @uno = uno.capitalize
    @due = due.capitalize
  end

  def print
    puts "#{@word}"
  end

  def giacenza
    conn = PG.connect(
      dbname: "ristorante",
      user: "postgres",
      password: "password",
      host: "localhost",
      port: 5432
    )

    File.write("giacenza.json", "")

    File.open("giacenza.json", "a") do |file|
      file.puts "["
      result = conn.exec("#{@uno}")
      result.each do |row|
        file.puts '{"ingrediente":"' + row["ingrediente"] + '","quantita":' + row["quantita"] + "," + '"giacenza":"' + row["giacenza"] + '"},'
      end
      file.puts "]"
    end

    conn.close
 end

 def tavolo
  conn = PG.connect(
    dbname: "ristorante",
    user: "postgres",
    password: "gattoTopo@89",
    host: "localhost",
    port: 5432
  )
  File.write("tavolo.json", "")

  File.open("tavolo.json", "a") do |file|
    file.puts "["
    result = conn.exec("#{@due}")
    result.each do |row|
      file.puts '{"tavolo":' + row["tavolo"] + ',"giorno":"' + row["giorno"] +'",' + '"orario":"' + row["orario"] + '","occupati":'+ row["occupati"]  + "},"
    end
    file.puts "]"
  end

  conn.close
 end
end

ptr = Run.new("Hello", "SELECT * FROM frigorifero;", "SELECT tavolo,giorno,orario,COUNT(recapito) AS occupati FROM prenotazione GROUP BY tavolo,giorno,orario ORDER BY giorno")
ptr.print
ptr.giacenza
ptr.tavolo
