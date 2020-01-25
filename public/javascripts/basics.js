$( document ).ready(function() {

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



});


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
