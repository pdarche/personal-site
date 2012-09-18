$(document).ready(function(){
		$('.delete_post').hover(function(){
		$(this).html('X').fadeIn()
	}, function(){
		$(this).empty();
	});

	$('.delete_post').click(function(){
		var postId = $(this).prev().html();
		var deletePost = confirm("are you sure you want to delete: " + postId);
		var deleteData = 'id=' + postId;
		var rowToDelete = $(this).parent()

		if(deletePost){
			$.ajax({
			  type: 'GET',
			  url: '/delete_post',
			  data: deleteData,
			  success: function(data){
			  	alert(data);
			  	rowToDelete.remove();
			  }
			});
		}
	});

		$('.post_title').click(function(){
		var id = $(this).next().html();
		console.log(id);
		var params = 'id=' + id;
		var fieldChanged = false;
		var updated = false;

		$.ajax({
		  type: 'GET',
		  url: '/get_post',
		  data: params,
		  success: function(data){

		  	var data = $.parseJSON(data);

		  	var projectId = data.id;
		  	$('#title').val(data.title);
		  	$('#tags').val(data.tags);
		  	$('#body').val(data.body);
		  	$('#intro_image').val(data.intro_image_url);
		  	$('#image_urls').val(data.image_urls);
		  	$('#video_url').val(data.video_url);

	  			value = $('.post_input').val();
		  		$('.post_input').change(value, function(){
		  			fieldChanged = true;
		  		
		  		if(fieldChanged){
		  			//hide new submit button
			  		$('#new_post_submit').hide();
			  		//remove preexisting update button
			  		$('.update_button').remove();
			  		//append new update button
			  		$('#post_form').append('<button id="update_button">update</button>');
			  		//post data
			  		var postdata = 'id=' + projectId + '&title=' + $('#title').val() + '&tags=' + $('#tags').val() + '&body=' + $('#body').val() + '&intro_image_url=' + $('#intro_image').val() + '&image_urls=' + $('#image_urls').val() + '&video_url=' + $('#video_url').val();

			  		$('#update_button').click(function(){
			  			$.ajax({
						  type: 'POST',
						  url: '/update_post',
						  data: postdata,
						  success: function(data){
						  	$('.post_input').val('');
						  	$('.update_button').remove();
						  	$('#new_post').append('<p id="update_status">update successful!</p>');
						  	$('#update_status').fadeOut(2500).queue(function(){
						  		$(this).remove();
						  		$('#new_post_submit').show();
						  		$(this).dequeue();
						  	});
						  }
						})
			  		})
		  		}
		  	})	
		  }
		});
	});	

})
