$(document).ready(function(){
	$('article').eq(0).css('border-top' , '0px');
	$('article').eq(0).css('padding-top' , '5px');

	var url = $('#page_link').find('a').eq(0).attr('href')
	var split = url.split('/')
	
	if(split[0] === '1'){
		$('#page_link').find('a').eq(1).hide();
		$('#page_link').find('p').hide();
	} 

	$.get('/post_count', function(data){
		if(data <= (parseInt(split[0]) * 4)){
			$('#page_link').find('a').eq(0).hide();
			$('#page_link').find('p').hide();
		}
	})
});