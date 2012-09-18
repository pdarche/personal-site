
$(function(){
 	// $('.project').hover(function(){
 	// 	$(this).append('<div class="project_cover" style="display:none"></div>');
 	// 	$('.project_cover').fadeIn();
 	// 	var title = $(this).find('.project_description').children().html();
 	// 	console.log(title);
 	// }, function(){
 	// 	$('.project_cover').fadeOut('fast').queue(function(){
 	// 		$('.project_cover').remove();
 	// 		$(this).dequeue();	
 	// 	})
 	// })
	if ($('.project').length < 6){
		$('#next_page').hide();
	}

});
