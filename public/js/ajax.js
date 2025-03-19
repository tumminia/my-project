const time = new Date();
const threeDays = 3*24*60*60*1000;
time.setTime(time.getTime() + (threeDays));
let expires = "expires="+time.toUTCString();
document.cookie = "XSRF-TOKEN="+$('meta[name="csrf-token"]').attr('content')+";"+expires+";path=/;";

$(function() {
	$.ajaxSetup({
	  headers: {
		'X-CSRF-TOKEN' : $('meta[name="csrf-token"]').attr('content')
	  }
	});
});

$(function(){
	$("#piatti").fadeIn(()=>{
		$.ajax({
			type:"POST",
			method:"POST",
			dataType:"json",
			url:"/json/piatti",
			data:{
				token:$('meta[name="csrf-token"]').attr('content')
			},
			error:(error)=>{
				console.log("Errore : "+error);
			},
			success:(data)=>{
				let tag = "<h4>Seleziona i piatti che preferisci <br/>(puoi fare massimo 10 ordini alla volta): </h4>";
				
				let antipasti = "";
				let primo = "";
				let secondo = "";
				let dolce = "";

				var word = "";
				const portata = (x)=> {
					word = "'"+ x +"'";
					
					str =
					'<div class="box" onclick="object.carrello(this,'+word+');" id='+word+' data-id='+word+'>' +
					'<div class="img">' +
					'<img src="/img/pasta.webp" alt='+word+'>' +
					'</div>' +
					'<div>' +
					x +
					'</div>' +
					'</div>'
					;

					return str;
				}

				$.each(data,(item,i)=>{
					categoria = i.categoria;
					switch(categoria) {
						case "Antipasti":
						antipasti += portata(i.nome);
						break;

						case "Primo":
						primo  += portata(i.nome);
						break;

						case "Secondo":
						secondo  += portata(i.nome);
						break;

						default:
						dolce  += portata(i.nome);
						break;
					}
				});

				$("#antipasti").find("div").append(antipasti);
				$("#primo").find("div").append(primo);
				$("#secondo").find("div").append(secondo);
				$("#dolce").find("div").append(dolce);
			}
		});
	});
});

var app = angular.module('myApp',['ngAnimate','ngCookies']);
let authToken = "";
app.config(function($httpProvider,$cookiesProvider) {
	authToken = $('meta[name="csrf-token"]').attr('content');
	$httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;
	
	life = $cookiesProvider.defaults = {
		  expires : expires,
	  };
});

app.controller('myCtrl',['$scope','$interval','$cookies','$http',function($scope,$interval,$cookies,$http){
    if(location.pathname=='/stock') {
	    $scope.tab = {'display' : 'inline-block'};
	    const req = {
		    method : 'GET',
		    url : '/json/giacenza.json',
		    headers : {'content-type' : 'application/json'},
		    data : {token : authToken}
		};
		
		$http(req).then(function(response){
			$scope.item = response.data;
			console.log("Http Status: "+response.status);
			}).catch(function(response) {
			console.log(
				"Http Status: "+response.status
				+ "Status of the XMLHttpRequest: "+response.statusText
			);
		});
    }
}]);

$(function(){
	$("#disponibile-button").on("click",()=>{
		let posti = $("#tab").val();
		let giorno =  $("#giorno").val();
		let orario = $("#orario").val();

		$.ajax({
			type:"POST",
			method:"POST",
			dataType:"json",
			url:"/json/tavolo",
			data:{
				token:$('meta[name="csrf-token"]').attr('content'),
				posti:posti,
				giorno:giorno,
				orario:orario
			},
			error:(error)=>{
				console.log("Errore : "+error);
			},
			success:(data)=>{
				
				let liberi = 3;

				$.each(data,(item,i)=>{
					if(parseInt(posti)===parseInt(i.posti) && giorno===i.giorno && orario===i.orario) {
						liberi = liberi - parseInt(i.prenotati);
					}
				});

				tag = "Tavoli da " + posti +" posti sono disponibili " + liberi + " tavoli per il giorno " + giorno + " e per l'orario " + orario;
				$("#messaggio").append("<h4>"+tag+"</h4>");
				liberi = 3;
			}
		});
	});
});

$(function(){
	$("#btn").on("click",()=>{
		let nome = $("#name").val();
		let numero = $("#tel").val();
		let posti = $("#num").val();
		let giorno =  $("#data").val();
		let orario = $("#ora").val();

		$.ajax({
			type:"POST",
			method:"POST",
			dataType:"json",
			url:"/json/prenota",
			data:{
				token:$('meta[name="csrf-token"]').attr('content'),
				nome:nome,
				numero:numero,
				posti:posti,
				giorno:giorno,
				orario:orario
			},
			error:(error)=>{
				console.log("Errore : "+error);
			},
			success:(data)=>{
				$.each(data,(item,i)=>{
					$("#prenota_tavolo").find('form').trigger("reset");
					$("#messageContainer").css({"display":"block"})
					$("#message").html("<h3 style='text-align:center;'>" + i.mex + "</h3>");
					console.log("token : " + i.token);
				});
			}
		});
	});
});
