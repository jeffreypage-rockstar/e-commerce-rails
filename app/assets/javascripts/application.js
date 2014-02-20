//= require admin/jquery-1.8.3.min
//= require jquery_ujs
//= require admin/breakpoints
//= require admin/jquery-ui-1.10.1.custom.min
//= require admin/jquery.slimscroll.min
//= require admin/bootstrap.min
//= require admin/jquery.blockui
//= require admin/jquery.cookie
//= require admin/jquery.vmap
//= require admin/jquery.vmap.russia
//= require admin/jquery.vmap.world
//= require admin/jquery.vmap.europe
//= require admin/jquery.vmap.germany
//= require admin/jquery.vmap.usa
//= require admin/jquery.vmap.sampledata
//= require admin/jquery.uniform.min
//= require admin/app
//= require foundation
//= require ckeditor/init
//= require_tree .

$(function(){ $(document).foundation(); });


jQuery(function() {
  $('body').prepend('<div id="fb-root"></div>');
  return $.ajax({
    url: "" + window.location.protocol + "//connect.facebook.net/en_US/all.js",
    dataType: 'script',
    cache: true
  });

  window.fbAsyncInit = function() {
    FB.init({
      appId: '',
      cookie: true
    });
    $('#sign_in').click(function(e) {
      e.preventDefault();
      return FB.login(function(response) {
        if (response.authResponse) {
          return window.location = '/auth/facebook/callback';
        }
      });
    });
    return $('#sign_out').click(function(e) {
      FB.getLoginStatus(function(response) {
        if (response.authResponse) {
          return FB.logout();
        }
      });
      return true;
    });
  };

  $('th:first input:checkbox').click(function(e) {
        var table = $(e.target).closest('table');
        console.log(table);
        $('td input:checkbox', table).each(function(){
            if (e.target.checked) {this.checked=true;console.log(this)} else{this.checked=false};
        });
        $('td .checker span').each(function(){
            if (e.target.checked) {$(this).addClass('checked');} else{$(this).removeClass('checked');};
        });
    });
});