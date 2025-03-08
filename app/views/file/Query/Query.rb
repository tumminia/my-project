require "pg"
require "json"

class Query
  def initialize(ingrediente)
    @ingrediente = ingrediente.capitalize
  end
  
  def csv
  conn = PG.connect(
    dbname: "ristorante",
    user: "postgres",
    password: "password",
    host: "localhost",
    port: 5432
  )

  File.write("giacenza.csv","")
  File.open("giacenza.csv","a") do |file|
    file.puts 'ingrediente,quantita,giacenza'
    result = conn.exec_params("SELECT * FROM frigorifero")
    result.each do |row|
      file.puts row['ingrediente'] + "," + row['quantita'] + "," + row['giacenza']
    end
  end

  conn.close
 end

 def queryDatabase
  conn = PG.connect(
    dbname: 'ristorante',
    user: 'postgres',
    password: 'password',
    host: 'localhost',
    port: 5432
  )

  ptr = @ingrediente + ".json"
  File.write(ptr,"")
  File.open(ptr,"a") do |file|
    result = conn.exec_params("SELECT * FROM frigorifero WHERE ingrediente IN ($1)",[@ingrediente.downcase])
    data = "["
    i=0

    result.each do |row|
      data += JSON.generate(row)
      
      if i<result.count-1
        data += "," 
      end

      i+=1;
    end

    data += "]"

    puts data
    file.puts data
    conn.close
  end
 end
end

print "Inserisci ingrediente:"
str = gets.chomp

ptr = Query.new(str)
ptr.csv
ptr.queryDatabase
