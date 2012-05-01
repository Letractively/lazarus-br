/*
	Simple HTML form serializer.
	Author: Silvio Clécio - silvioprog@gmail.com
*/

// Mude para sua URL de preferência.
var rootURL = 'http://localhost/cgi-bin/lwsjdo.lws';

// Aqui eu desabilito o submit do form.
$('form').submit(function() {
	return false;
});

// Aqui eu pego o evento do botão "Save" que, ao ser clicado, dá um POST para persistir os dados e limpa a tela.
$('#save').click(function() {
	addPerson();
	clearForm();
	return false;
});

// Aqui eu serializo o formulário (de uma forma medievál, mas isso é só um exemplo brow! :) ). A saída dessa função é, por exemplo: { "name": "CHIMBICA" }
function formToJSON() {
	return JSON.stringify({
		"name": $('#name').val()
	});
}

// Limpa o form com direito a talquinho no bumbum. *-*
function clearForm() {
	$('input').val('');
}

/*
	Enfim, minha parte predileta: o ajax!
	Dou um POST com content-type do tipo JSON, caso tudo ocorra bem, o CGI se vira nos 30 para chamar a classe de persistênci e salvar o registro na tabela,
	caso algo dê errado, mostro uma mensagem com o erro.
*/
function addPerson() {
	$.ajax({
		type: 'POST',
		contentType: 'application/json',
		url: rootURL,
		dataType: 'json',
		data: formToJSON(),
		success: function(data, textStatus, jqXHR){
			alert('Person inserted succesfully!');
		},
		error: function(jqXHR, textStatus, errorThrown){
			alert('Insert person error: ' + textStatus + '\n\n' + errorThrown);
		}
	});
}