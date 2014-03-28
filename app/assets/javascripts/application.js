//= require admin/jquery-1.8.3.min
//= require bootstrap/bootstrap
//= require bootstrap/bootstrap-collapse
//= require bootstrap/bootstrap-dropdown
//= require new_sliders/carouFredSel
//= require product_page/jquery.jcarousel.pack
//= require new_sliders/jquery.bxslider
//= require jquery_ujs
//= require admin/breakpoints
//= require admin/jquery-ui-1.10.1.custom.min
//= require admin/jquery.slimscroll.min
//= require admin/bootstrap.min
//= require admin/bootstrap-colorpicker
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
//= require ckeditor/init


$(function(){ 
  //$(document).foundation();
  $('.carousel').carousel();
  $('#myCarousel').on('slid', function() {
      var to_slide = $('#myCarousel .carousel-inner .item.active').attr('id');
      $('.carousel-indicators').children().removeClass('active');
      $('.carousel-indicators [data-slide-to=' + to_slide + ']').addClass('active');
  });
  $('#MyProdctslider').on('slid', function() {
      var to_slide = $('#MyProdctslider .carousel-inner .item.active').attr('id');
      $('.product-indicators ul li .active').removeClass('active');
      $('.product-indicators [data-slide-to=' + to_slide + ']').addClass('active');
  });

  $('#MyDiscountslider').on('slid', function() {
      var to_slide = $('#MyDiscountslider .carousel-inner .item.active').attr('id');
      $('.product-indicators ul li .active').removeClass('active');
      $('.product-indicators [data-slide-to=' + to_slide + ']').addClass('active');
  });
  
  $('.my-img').click(function(){
    $('.my-img a').slideToggle();
    $('.login-div').slideToggle();
  });
  $('.slider1').bxSlider({
      slideWidth: 1640 ,
      minSlides: 1,
      maxSlides: 1,
      slideMargin: 0
    });
  $('.products_bigimage_slider').bxSlider({
      slideWidth: 1500,
      minSlides: 5,
      maxSlides: 10,
      slideMargin: 0
    });
  $('.products_smallimage_slider').bxSlider({
      slideWidth: 1500,
      minSlides: 7,
      maxSlides: 21,
      slideMargin: 0
    });
  $("#product_prototype_id").click (function(){
     jQuery.ajax( {
           type : "GET",
           url : '/admin/merchandise/products'+'/'+$("#product_prototype_id option:selected").first().val()+"/add_properties",
           data : { product_id : $(this).attr('data-product_id') },
           complete : function(json) {
             // open dialog with html
             Hadean.AdminMerchandiseProductForm.refreshProductForm(json);
            // STOP  WAIT INDICATOR...
           },
           dataType : 'json'
        });
  });

  $('body').prepend('<div id="fb-root"></div>');
  return $.ajax({
    url: "" + window.location.protocol + "//connect.facebook.net/en_US/all.js",
    dataType: 'script',
    cache: true
  });

  window.fbAsyncInit = function() {
    FB.init({
      appId: '1377312692524865',
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

});

