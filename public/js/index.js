var counter = 0;
class App {
    carrello(a) {
        let x = "";
        if (10 > counter) {
            var b = 1e18 * Math.random();
            x = "<li id='" + b + "'>" + a.id + "; <i onclick='object.clear(" + b + ");' class='bi bi-x text-danger'></i></li>",
            $("#carrello").find("ol").append(x),
            counter++
        } else 
            alert("Hai superato " + counter + " ordini")
    }
    clear(a) {
        document.getElementById(a).remove(),
        counter--;
    }
}
const object = new App;
