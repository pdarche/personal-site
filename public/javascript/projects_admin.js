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

		if(deletePost){
			$.ajax({
			  type: 'GET',
			  url: '/delete_project',
			  data: deleteData,
			  success: function(data){
			  	alert(data);
			  }
			});
		}
	});

	$('.project_title').click(function(){
		var id = $(this).next().html();
		var params = 'id=' + id;
		var fieldChanged = false;
		var updated = false;

		$.ajax({
		  type: 'GET',
		  url: '/get_project',
		  data: params,
		  success: function(data){

		  	var data = $.parseJSON(data);

		  	//set fields equal to values for project
		  	var projectId = data.id;
		  	$('#title').val(data.title);
		  	$('#collaborators').val(data.collaborators);
		  	$('#short_description').val(data.short_description);
		  	$('#long_description').val(data.long_description);
		  	$('#motivation').val(data.motivation);
		  	$('#process').val(data.process);
		  	$('#small_image_url').val(data.small_image_url);
		  	$('#video_url').val(data.video_url);

		  	// $('.project_input').click(function(){		  		
	  			value = $('.project_input').val();
		  		$('.project_input').change(value, function(){
		  			fieldChanged = true;
				
		  			if(fieldChanged){ 
				  		//hide submit button
				  		$('#new_project_submit').hide();
				  		//remove update button from previous updates
				  		$('.update_button').remove();
				  		//append new update button with lastest update data
				  		$('#project_form').append('<button class="update_button">update</button>');
				  		
				  		//form data from update 
				  		var postdata = 'id=' + projectId + '&title=' + $('#title').val() + '&collaborators=' + $('#collaborators').val() + '&short_description=' + $('#short_description').val() + '&long_description=' + $('#long_description').val() + '&motivation=' + $('#motivation').val() + '&process=' + $('#process').val() + '&small_image_url=' + $('#small_image_url').val() + '&video_url=' + $('#video_url').val();
				  		//ajax post on update button click
				  		$('.update_button').click(function(){
				  			console.log("clicked");
				  			$.ajax({
							  type: 'POST',
							  url: '/update_project',
							  data: postdata,
							  success: function(data){						  	
							  	$('.project_input').val('');
							  	$('.update_button').remove();
							  	$('#new_project').append('<p id="update_status">update successful!</p>');
							  	$('#update_status').fadeOut(2500).queue(function(){
							  		$(this).remove();
							  		$('#new_project_submit').show()
							  		$(this).dequeue();
							  	});
							  }
							})
				  		})
			  		}
				})
		  		
		  	//})	
		  }
		});
	});



});