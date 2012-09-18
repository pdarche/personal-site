$(document).ready(function(){
	$('#description, .comments, footer').hide();	
	
	var expanded = false;
	$('#additional_content').click(function(){
		if(!expanded){
			$('#description, .comments, footer').fadeIn(1000);
        	$('html, body').animate({scrollTop: $('#description').height() + 100}, 800);
        	$('#additional_content').html('less');
			expanded = !expanded;
		}else{
			$('#description, .comments, footer').fadeOut();
			$('html, body').animate({scrollTop: 0}, 'slow');
        	$('#additional_content').html('more');
			expanded = !expanded;
		}
	})
})