$(document).ready(function(){
	$('#comment_link').click(function(){
		//create variable of post id
		var id = $('#post_id').html();
		//append backgound
		$('body').append('<div id="back_fade"></div>');
		//fade in comment form
		$('#comment_form').fadeIn();
		//set hidden form value to current post Id
		$('#postId').val(id);

		console.log($('#postId').val())
		
	
		hideFade();
	})
});

function hideFade(){
		$('#back_fade').click(function(){
		console.log("clicked")
		//clear post form
		$('.post_input').val('');
		//hide post form
		$('#comment_form').hide();

		$('#back_fade').fadeOut().queue(function(){
			$(this).remove();
			$(this).dequeue();
		})
	})
}