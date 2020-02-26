
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
function expand(){
  $(this).toggleClass("on");
  $(".menu").toggleClass("active");
  $(".site-title").toggleClass("site-title-active");
  $(".site-title").removeClass("menu-win-scroll");

};

$( document ).ready(function() {


  jQuery.fn.highlight = function ( className) {
    return this.each(function () {
      this.innerHTML = this.innerHTML.replace(/-?[\d+()\+\%]/g, function(matched) {return "<span class=\"" + className + "\">" + matched + "</span>";});
    });

  };

  // highlight function
  //////////////////////
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


  $(".menu-button").on('click', expand);

  var lastScrollTop = 0;
  // element should be replaced with the actual target element on which you have applied scroll, use window in case of no target element.
  window.addEventListener("scroll", function(){ // or window.addEventListener("scroll"....
  var st = window.pageYOffset || document.documentElement.scrollTop;// Credits: "https://github.com/qeremy/so/blob/master/so.dom.js#L426"
  if (st > lastScrollTop && $(".active").length == 0){
    $(".site-title").addClass("menu-win-scroll");

        $(".rating-selector").addClass("rating-select-scroll");
  } else {
    $(".site-title").removeClass("menu-win-scroll");
        $(".rating-selector").removeClass("rating-select-scroll");
  }
  lastScrollTop = st <= 0 ? 0 : st; // For Mobile or negative scrolling
}, false);

///////////////////

function compareme(e){
  var path = null;
  var searchQuery = document.getElementById("search").value.split(" ").join("%20");

  e = e.replace(/[ ]/g, '%20'); // makes sure the strings are good for urls

  console.log(e);
    path = "/childs/compare/" + e;

  $(".popper").load(path + ' .comparison-profile-container', function () {
    $('header').hide();
    $('.popper').css("visibility", "visible");

    $('.exit-button2').css("visibility", "visible")
    // $('main').css("visibility", "hidden");
    // this keeps track of scroll position before overlay
    scrollPosition = window.pageYOffset;


    var cont = null;
    if (document.querySelector('.main-cont') == null) {
       cont = document.querySelector('.container-fluid');
    } else {
      cont = document.querySelector('.main-cont');
    }
  const mainEl = cont;
    mainEl.style.top = -scrollPosition + 'px';
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
    $('td').each(function() {
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
};

$('.name-list').on('submit', function(e) {

  var checkedValue = null;
  var inputElements = document.getElementsByClassName('unit-names');
  for(var i=0; inputElements[i]; ++i){
        if(inputElements[i].checked){
          if (checkedValue != null) {
            checkedValue = (checkedValue + "," + inputElements[i].value);
            // console.log("this is the checkedvaled: " + checkedValue);
            compareme(checkedValue.toLowerCase());
            // console.log("Did this only once");
            inputElements[i].checked = false;
             $(':checkbox:not(:checked)').prop('disabled', false);
            return false;
          }
          checkedValue = inputElements[i].value;
          inputElements[i].checked = false;
        }
  }
  e.preventDefault;
  return false;
});

$("#search").keydown(function(e){
  if (e.which == 13) {
      return false;
  }
  var current_query = $("#search").val().toLowerCase().split(",");
  if (current_query[0].length == 0) {
    $(".name-list li").show();
    return;
  }
  var name1 = current_query[0]
  var name2 = current_query[1]


    $(".name-list li").hide();

    $(".name-list li").each(function(idx,name){
      var current_name = $(this).text().substring(1).toLowerCase();
      if (current_name.includes(name1) || current_name.includes(name2)){

        // console.log(name);
        $(this).show();
    }
    });

}); //search function end


function removeOverlay()  {
  $('header').show();
  // $('.main-cont').show();
  // this restores track of scroll position before overlay
  window.scrollTo(0, scrollPosition);
  // var cont = null;
  // if (document.querySelector('.container-fluid') == null) {
  //   cont = document.querySelector('.main-cont');
  // } else {
  //  cont = document.querySelector('.container-fluid');
  // }
  // const mainEl = cont;
  // mainEl.style.top = 0;
  $('.popper').scrollTop(0);
  // end
  $('main').css("visibility", "visible");
  $('.popper').css("visibility", "hidden");
  $('.popper').find('.main-profile-container').remove('.main-profile-container');

  $('.popper').find('.comparison-profile-container').remove('.comparison-profile-container');
};

$(document).on('click', '.exit-button2', function(e){
  removeOverlay();
});



$(":checkbox[name='checkboxes']").change(function(){
  if ($(":checkbox[name='checkboxes']:checked").length == 2)
   $(':checkbox:not(:checked)').prop('disabled', true);
  else
   $(':checkbox:not(:checked)').prop('disabled', false);
});

///////////// main search functions

  $('#search2').on('keypress',function(e) {
      if(e.which == 13) {
        if ($(":checkbox[name='skills']:checked").length == 1) {
          // $('.unit-cont').load('/search-results');
    console.log($(":checkbox[name='skills']:checked").length == 1);

        window.location.replace("/search-results/skills/" + $("#search2").val());
    return false;
         // $(':checkbox:not(:checked)').prop('disabled', true);
       } else {
        // console.log("loaded");
    window.location.replace("/search-results/units/" + $("#search2").val());
            return false;
          // $('.unit-cont').load('/search-results');
         // $(':checkbox:not(:checked)').prop('disabled', false);
         }

      }
  });


  // $('#3stars').click(function(e) {
  //
  //   $('.unit-cont').load('/tiers/3');
  // });
  //
  // $('#4stars').click(function(e) {
  //
  //
  //   $('.unit-cont').load('/tiers/4');
  // });
  //
  // $('#5stars').click(function(e) {
  //   console.log('loaded');
  //   if (window.location.href.endsWith('5')) {
  //     return false;
  //   }
  //   $('.unit-cont').load('/tiers/5');
  // });

});  // document ready function end

function checkMe(e) {
  this.preventDefault;
  return confirm("Do you want to delete: " + e.toUpperCase() + " permanently?");
};
// POPOUT FUNCIONS
//////////////////////
$(document).on('click', '.linkaddress', function(e){
  e.preventDefault();

  var path = this.href;
  $(".popper").load(path + ' .main-profile-container', function () {
    $('header').hide();
    $('.popper').css("visibility", "visible");

    $('.exit-button2').css("visibility", "visible")
    // $('main').css("visibility", "hidden");
    // this keeps track of scroll position before overlay
    scrollPosition = window.pageYOffset;

    const mainEl = document.querySelector('.main-cont');

    mainEl.style.top = -scrollPosition + 'px';
    // scroll check end
    // e.preventDefault();
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
    $('td').each(function() {
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

////////////////////////
// back to top scroll button
window.onscroll = function() {scrollFunction()};

function scrollFunction() {
  console.log(document.documentElement.scrollTop);
  if (document.documentElement.scrollTop > 100) {
    document.getElementById("myBtn").style.display = "block";
  } else {
    document.getElementById("myBtn").style.display = "none";
  }
}

function topFunction(){
  document.body.scrollTop = 0; // For Safari
  document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
}

// POPOUT FUNCIONS end
//////////////////////
function mobileHide(size) {

  //// YOU WANT TO REMOVE THE 'HIDE' CLASS ON THE PROFILEIMG-CONTAINER AND ADD THE TO THE PIC THEMSELVES
  /// THEN YOU CAN REMOVE AND ADD THEM EASILY DURING DIFFERENT DISPLAY WIDTHS.

  // if (size == "small") {
  //   // $('#pic-button1').addClass('hide');
  //   //   $('#pic-button2').removeClass('hide');
  //   // $('.pro-img-container').removeClass('hide');  // use this one
  //   $('.pro-image-small').removeClass('hide');
  //   $('.pro-image-full').addClass('hide');
  //
  //   $('.pro-image-small').css("display", "initial"); // use this one
  //   $('.pro-image-full').css("display", "none"); // use this one
  // } else {
  //   // $('#pic-button2').addClass('hide');
  //   // $('#pic-button1').toggleClass('hide');
  //   // $('.pro-img-container').removeClass('hide'); // use this one
  //   $('.pro-image-small').addClass('hide');
  //   $('.pro-image-full').removeClass('hide');
  //   $('.pro-image-full').css("display", "initial"); // use this one
  //   $('.pro-image-small').css("display", "none"); // use this one
  //
  // }
  $('.mobile').addClass('show');

    // $('pro-img-container').removeClass('mobile');
  if (size == "small") {
        $('.pro-image-small').addClass('show');
        $('.pro-image-full').removeClass('show');

        $('.pro-image-full').addClass('hide');
  } else {
      $('.pro-image-small').removeClass('show');
      $('.pro-image-full').addClass('show');
  }

};

function  showUnitsTier(type) {
  // $('.item').removeClass('hide-list');
  $('.main-cont .item').each(function(){
    if($(this).hasClass(type)) {
      if ($(this).hasClass('hide-list') === false) {
        return false;
      }
      // console.log(this);
      $(this).removeClass('hide-list');
    } else {
$(this).addClass('hide-list');
  }
});
};

function checkUrl(e) {
  // console.log('test');
  e.preventDefault;
   var url = window.location.href;
   if (url.endsWith(e)) {
     // console.log('gsgd');
     // console.log($('.rating-selector-groups > a'));
     return false;
     // location.reload();
   } else {
     // url = url.slice(0,-1) + e;
     // window.location.replace(url);
     window.location.href = this.location.href;
   }
};
