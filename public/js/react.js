class Index extends React.Component {
    menu() {
        return (
        <>
        <div title="Home page"><a href="/">Home</a></div>
        <div title="Prenotazione dal tavolo"><a href="/page">Ordina</a></div>
        <div title="Giacenza frigorifero"><a href="/sqlite3">Giacenza</a></div>
        <div title="Tavoli disponibili"><a href="/table">Tavoli</a></div>
        <div title="Prenota un tavolo"  data-bs-toggle='modal' data-bs-target='#prenota_tavolo' data-bs-whatever='@mdo'>Prenota</div>  
        </>
        );
    }

    messageContainer(){
        return(
        <>
        <div>
        <button id="close">
        <i className="bi bi-x-circle-fill"></i>
        </button>
        </div>
        <div id="message"></div>
        </>
        );
    }

    footer() {
        return(
        <>
        <div>
        <h4>Informazioni:</h4>
        <ol>
        <li>Via Roma 001, CAP 20100 Milano</li>
        <li>Lunedì - Venerdì: 12:00 - 23:00</li>
        <li>Sabato: 13:00 - 00:00</li>
        <li>Domenica: Chiuso</li>
        </ol>
        </div>
        
        <div>
        <h4>Contatti:</h4>
        <ol>
        <li><a href="#"><i className="bi bi-telephone"></i> +39 0123456789</a></li>
        <li><a href="#"><i className="bi bi-whatsapp"></i> +39 0987654321</a></li> 
        <li><a href="#"><i className="bi bi-envelope-at"></i> luigi@food.it</a></li>   
        </ol>
        </div>
        
        <div>
        <h4>Social:</h4>
        <ol>
        <li><a href="#"><i className="bi bi-facebook"></i> Facebook</a></li>
        <li><a href="#"><i className="bi bi-instagram"></i> Instagram</a></li>
        <li><a href="#"><i className="bi bi-linkedin"></i> Linkedin</a></li>
        <li><a href="#"><i className="bi bi-tiktok"></i> Tiktok</a></li>
        </ol>
        </div>
        </>
        );
    }
}

const root = (id)=>{
    return ReactDOM.createRoot(document.getElementById(id));
}

const index = new Index()
root("link").render(<index.menu/>);
root("messageContainer").render(<index.messageContainer/>);
root("footer").render(<index.footer/>);