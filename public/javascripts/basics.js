
// #############################
// Fit text
// #############################
(function( $ ){

  $.fn.fitText = function( kompressor, options ) {

    // Setup options
    var compressor = kompressor || 1,
        settings = $.extend({
          'minFontSize' : Number.NEGATIVE_INFINITY,
          'maxFontSize' : Number.POSITIVE_INFINITY
        }, options);

    return this.each(function(){
      // Store the object
      var $this = $(this);

      // Resizer() resizes items based on the object width divided by the compressor * 10
      var resizer = function () {
        $this.css('font-size', Math.max(Math.min($this.width() / (compressor*10), parseFloat(settings.maxFontSize)), parseFloat(settings.minFontSize)));
      };

      // Call once to set.
      resizer();

      // Call on resize. Opera debounces their resize by default.
      $(window).on('resize.fittext orientationchange.fittext', resizer);

    });

  };

})( jQuery );
    // $(".unit-profile-title").fitText(2.9);

// #############################
// Fit text end
// #############################
$( document ).ready(function() {


    jQuery.fn.highlight = function ( className) {
      return this.each(function () {
          console.log(this.innerHTML);
          this.innerHTML = this.innerHTML.replace(/-?[\d+()\+\%]/g, function(matched) {return "<span class=\"" + className + "\">" + matched + "</span>";});
        });

  };

  // highlight function
  $('p').each(function() {
    // checks if a <p> element has img imbedded.
    // if it does, then it skips the HIGHLIGHTING, else it highlights
    var name = $(this).children("img").length == 0;  // checks if the img element returns 0 or not

    if (name) {
      $(this).highlight("highlight");
    } else  {
        return;
      }
  });

  function expand(){
  $(this).toggleClass("on");
  $(".menu").toggleClass("active");
  $(".site-title").toggleClass("site-title-active");
  // $(".site-title").toggleClass("active");
  $(".site-title").removeClass("menu-win-scroll");
};
$(".menu-button").on('click', expand);


var lastScrollTop = 0;
// element should be replaced with the actual target element on which you have applied scroll, use window in case of no target element.
window.addEventListener("scroll", function(){ // or window.addEventListener("scroll"....
   var st = window.pageYOffset || document.documentElement.scrollTop;// Credits: "https://github.com/qeremy/so/blob/master/so.dom.js#L426"
   if (st > lastScrollTop && $(".active").length == 0){
        $(".site-title").addClass("menu-win-scroll");
   } else {
        $(".site-title").removeClass("menu-win-scroll");
   }
   lastScrollTop = st <= 0 ? 0 : st; // For Mobile or negative scrolling
}, false);

// POPOUT FUNCIONS
$(document).on('click', '.linkaddress', function(e){
  // $('#popout').show();
  // $('.exit-button2').show();
  // $('.exit-button2').css("visibility", "visible")

  // $('main').css("visibility", "hidden")
    e.preventDefault();


  var path = this.href;
  console.log(path);
      $(".popper").load(path + ' .main-profile-container', function () {
        $('header').hide();
        $('.main-cont').hide();
        // highlight function
          $('p').each(function() {
            // checks if a <p> element has img imbedded.
            // if it does, then it skips the HIGHLIGHTING, else it highlights
            var name = $(this).children("img").length == 0;  // checks if the img element returns 0 or not

            if (name) {
              $(this).highlight("highlight");
            } else  {
                return;
              }
          });

      });

  });

  $(document).on('click', '.unit_name', function(e){
  $('header').show();
  $('.main-cont').show();

  $('main').css("visibility", "visible");
  $('.popper').find('.main-profile-container').remove('.main-profile-container');
  });

  $(document).on('click', '.sc-profile-title', function(e){
  $('header').show();
  $('.main-cont').show();

  $('main').css("visibility", "visible");
  $('.popper').find('.main-profile-container').remove('.main-profile-container');
  });


});  // document ready function end


// back to top scroll button
window.onscroll = function() {scrollFunction()};

function scrollFunction() {
  if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
    document.getElementById("myBtn").style.display = "block";
  } else {
    document.getElementById("myBtn").style.display = "none";
  }
}

function topFunction(){
  document.body.scrollTop = 0; // For Safari
  document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
}

function mobileHide() {
  $('.mobile-button').toggleClass('hide');
  $('.pro-img-container').toggleClass('hide');
};

$('#3stars').click(function() {
console.log('loaded');
  $('.unit-cont').load('/tiers/5')
});
$('#4stars').click(function() {
console.log('loaded');
  $('.unit-cont').load('/tiers/5')
});
$('#5stars').click(function() {
console.log('loaded');
  $('.unit-cont').load('/tiers/5')
});
