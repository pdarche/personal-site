/******************************************** GLOBAL CODE *******************************************************/

var title = '#'+String($('title').html());

//title.replace(" ", "#");

$('li:has(title)').css("border" , "1px solid white");

console.log();

var hidden = false;
$('#linkControl').click(function(){
    if(hidden){
        $('.links').slideDown();
        $('#linkControlContent').html("hide");
        $('#linkList').delay(500).fadeIn(250);
        $('#linkControl').css({"top":"-10px;"});
        hidden = false;
        
    }else{
        $('#linkList').hide();
        $('.links').slideUp();
        $('#linkControlContent').html("show");
        $('#linkControl').css({"top":"-15px;"});
        hidden = true;
    }
});     

loginCreated = false;

$('#login').click(function(){
    if(loginCreated == false){
        $('.content').append('<form id="loginForm" action="../global_resources/login.php" method="POST"><input id="username" type="text" name="username"/><input id="password" type="password" name="password"/><input id="logInSubmit" type="submit" name="logInSubmit" value="log in"></form>');
        $('#loginForm').hide().fadeIn();
        $('#logInSubmit').hide();
        loginCreated = true;
    }
});  

$('.content').keyup(function(){
        if($('#username').val() != "" && $('#password').val() != "" && loginCreated){
            $('#logInSubmit').fadeIn();
    }
    });

var inputString;
$('#username, #password').keyup(function(){
        inputString = $('#username').val();
        alert(inputString);
    });
