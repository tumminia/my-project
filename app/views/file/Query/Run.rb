require 'pg'
require 'json'

class Run
  def initialize(word)
    @word = word.capitalize
  end

  def print
    puts "#{@word}"
  end

  def giacenza
    conn = PG.connect(
      dbname: 'ristorante',
      user: 'postgres',
      password: 'password',
      host: 'localhost',
      port: 5432
    )
    File.write("giacenza.json","")

    i = 0

    File.open('giacenza.json', 'a') do |file|
      result = conn.exec_params("SELECT * FROM frigorifero")
      data = "["
      
      result.each do |row|      
         data +=JSON.generate(row)
         
         if i<result.count-1
          data += ","
         end

         i+=1
      end

      data += "]"
      file.puts data
    end
    
    conn.close
 end

 def tavolo
  conn = PG.connect(
    dbname: 'ristorante',
    user: 'postgres',
    password: 'password',
    host: 'localhost',
    port: 5432
  )
  File.write("tavolo.json","")

  i = 0

  File.open('tavolo.json', 'a') do |file|
    result = conn.exec_params(
      'SELECT tavolo,giorno,orario,COUNT(recapito) AS occupati FROM prenotazione GROUP BY tavolo,giorno,orario ORDER BY giorno'
    )
    data = "["

    result.each do |row|      
      data += JSON.generate(row)

      if i<result.count-1
        data += ","
      end

      i +=1
    end

    data += "]"
    file.puts data
  end
  
  conn.close
 end
end

ptr = Run.new('Hello')
ptr.print
ptr.giacenza
ptr.tavolo
