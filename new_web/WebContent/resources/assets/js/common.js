/**
 * 
 */

function movePage(target, url, params){
 	if(console){
 		console.log(target);
 		console.log(url);
 		console.log(params);
 	}
	if(params == undefined) params = {};
	$.ajax({
		url: ctx+url,
		data : params,
		success : function (data, textStatus, XMLHttpRequest) {
			$("div#contentArea").html( data );
			
		},
		error : function (XMLHttpRequest, textStatus, errorThrown) {
			$(tabId, myLayout.panes.center).html(XMLHttpRequest.responseText);
		}
	});
}