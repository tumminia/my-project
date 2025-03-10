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
			type:"GET",
			method:"GET",
			dataType:"json",
			url:"/json/piatti.json",
			data:{
				token:$('meta[name="csrf-token"]').attr('content')
			},
			error:(error)=>{
				console.log("Errore : "+error);
			},
			success:(data)=>{
				let tag = "<h4>Seleziona i piatti che preferisci:";
				let antipasti = "<h5>Antipasti:</h5>";
				let primo = "<h5>Primo:</h5>";
				let secondo = "<h5>Secondo:</h5>";
				let dolce = "<h5>Dolce:</h5>";

				+" puoi fare massimo 10 ordini alla volta. </h4>";
				var word = "";
				const portata = (x)=> {
					word = "'"+ x +"'";
					
					str =
					'<div class="box" onclick="object.carrello('+word+');">' +
					'<div class="img">' +
					'<img src="/img/pasta.webp">' +
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

				$("#piatti").append(tag);
				$("#piatti").append(antipasti);
				$("#piatti").append(primo);
				$("#piatti").append(secondo);
				$("#piatti").append(dolce);
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
		$.ajax({
			type:"GET",
			method:"GET",
			dataType:"json",
			url:"/json/tavolo.json",
			data:{
				token:$('meta[name="csrf-token"]').attr('content')
			},
			error:(error)=>{
				console.log("Errore : "+error);
			},
			success:(data)=>{
				let tavolo = $("#tab").val();
				let giorno =  $("#giorno").val();
				let orario = $("#orario").val();
				let liberi = 3;

				$.each(data,(item,i)=>{
					if(parseInt(tavolo)===parseInt(i.tavolo) && giorno===i.giorno && orario===i.orario) {
						liberi = liberi - parseInt(i.occupati);
					}
				});

				tag = "Tavoli da " + tavolo +" posti sono disponibili " + liberi + " tavoli per il giorno " + giorno + " e per l'orario " + orario;
				$("#messaggio").append("<h4>"+tag+"</h4>");
				liberi = 3;
			}
		});
	});
});
