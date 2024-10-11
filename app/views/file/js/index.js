var counter = 0;
var array = [null,null,null,null,null,null,null,null,null,null];
class App {
    carrello(info) {
        let tag = "";
        
        if(counter<10) {
            var x = Math.random() * 1000000000000000000; //10^18
            tag = 
            "<p id='" + x + "'style='text-align:center;'>" + 
            info + 
            " <i onclick='object.clear(" + x + ");' class='bi bi-x text-danger'></i>" + 
            "</p>";

            alert("Ordine " + info + " aggiunto nel carrello!!!");
            $("#carrello").append(tag);
            counter++;
        } else {
            alert("Hai superato " + counter + " ordini");
        }
    }

    clear(info) {
        var id = "#"+info;
        $(id).html("");
        counter--;
    }
}

const object = new App();
