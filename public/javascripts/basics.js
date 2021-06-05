// #############################
// Fit text
// #############################
(function( $ ){

  $.fn.fitText = function( kompressor, options ) {
console.log('I ran');
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


$("main").click(function() {
  console.log('clicked');
  if ($(".menu").hasClass("active")) {
  $(".menu").toggleClass("active");
  }
});

$( document ).ready(function() {

  jQuery.fn.highlight = function highlight( className) {
    return this.each(function () {
      this.innerHTML = this.innerHTML.replace(/-?[\d+\(\)\+\%]*(?!(?:(?!<\/?a\b[^>]*>).)*?<\/a>)/g, function(matched) {
        if (matched.length !== 0) {
        return "<span class=" + className + ">" + matched + "</span>";
      } else {
        return matched;
      }
    });
    });

  };

  //direct link (open in new window) highlighting
      highlightParagraph();

//   $(".menu-button").on('click', expand);
//
//   var lastScrollTop = 0;
//   // element should be replaced with the actual target element on which you have applied scroll, use window in case of no target element.
//   window.addEventListener("scroll", function(){ // or window.addEventListener("scroll"....
//   var st = window.pageYOffset || document.documentElement.scrollTop;// Credits: "https://github.com/qeremy/so/blob/master/so.dom.js#L426"
//   if (st > lastScrollTop && $(".active").length == 0){
//     // $(".site-title").addClass("menu-win-scroll");
//
//         // $(".rating-selector").addClass("rating-select-scroll");
//   } else {
//     // $(".site-title").removeClass("menu-win-scroll");
//         // $(".rating-selector").removeClass("rating-select-scroll");
//   }
//   lastScrollTop = st <= 0 ? 0 : st; // For Mobile or negative scrolling
// }, false);

///////////////////

function compareme(e){
  var path = null;
  var searchQuery = document.getElementById("search").value.split(" ").join("%20");

  e = e.replace(/[ ]/g, '%20'); // makes sure the strings are good for urls

    path = "/childs/compare/" + e;

  $(".popper").load(path + ' .comparison-profile-container', function () {
    $('header').hide();
    $('.popper').css("visibility", "visible");

    $('.exit-button2').css("visibility", "visible");
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

  });
}

$('.name-list').on('submit', function(e) {

  var checkedValue = null;
  var inputElements = document.getElementsByClassName('unit-names');
  for(var i=0; inputElements[i]; ++i){
        if(inputElements[i].checked){
          if (checkedValue != null) {
            checkedValue = (checkedValue + "," + inputElements[i].value);
            compareme(checkedValue.toLowerCase());
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
////compare search
// $("#search").keydown(function(e){
//   if (e.which == 13) {
//       return false;
//   }
//   var current_query = $("#search").val().toLowerCase().split(",");
//   if (current_query[0].length == 0) {
//     $(".name-list li").show();
//     return;
//   }
//   var name1 = current_query[0]
//   var name2 = current_query[1]
//
//
//     $(".name-list li").hide();
//
//     $(".name-list li").each(function(idx,name){
//       var current_name = $(this).text().substring(1).toLowerCase();
//       if (current_name.includes(name1) || current_name.includes(name2)){
//
//         $(this).show();
//     }
//     });
//
// }); //search function end


function removeOverlay()  {
  $('header').show();
  $('.popper').scrollTop(0);
  // end
  $('main').css("visibility", "visible");
  $('.main-cont').removeClass('hide-main-cont');
  window.scrollTo(0, scrollPosition);
  $('.popper').css("visibility", "hidden");
  $('.popper').find('.main-profile-container').remove('.main-profile-container');

  $('.popper').find('.comparison-profile-container').remove('.comparison-profile-container');
};

$(document).on('click', '.exit-button2', function(e){
  removeOverlay();
  $('.exit-button2').css("visibility", "hidden"); // this removes the button from layout.
});



$(":checkbox[name='checkboxes']").change(function(){
  if ($(":checkbox[name='checkboxes']:checked").length == 2)
   $(':checkbox:not(:checked)').prop('disabled', true);
  else
   $(':checkbox:not(:checked)').prop('disabled', false);
});

///////////// main search functions

setTimeout(function(){
  $('.message').remove();
}, 2500);
  // $(".message").click(function() {
  //   $('.message').remove();
  // });

if(localStorage.getItem('popState') != 'shown4'){
        $("#serverpopupv2").delay(1000).fadeIn();
        localStorage.setItem('popState','shown4')
    }

    $('#serverpopup-close').click(function(e) // You are clicking the close button
    {
    $('#serverpopupv2').fadeOut(); // Now the pop up is hiden.
    });
    $('#serverpopupv2').click(function(e)
    {
    $('#serverpopupv2').fadeOut();
    });


    $("#search2").keyup(function() {

       // Retrieve the input field text and reset the count to zero
       var filter = $(this).val();
       var count = 0;

       // Loop through the comment list
       $('.unit-grid-cols').each(function() {
             // var title = $(this).text().trim();

             // If the list item does not contain the text phrase fade it out
             if ($(this).text().search(new RegExp(filter, "i")) < 0) {
               $(this).hide();  // MY CHANGE

               // Show the list item if the phrase matches and increase the count by 1
             } else {
               $(this).show(); // MY CHANGE
               count++;
             }
       });

     });

     $("#idx").on("keyup", function() {
       var value = $(this).val().toLowerCase();
         console.log($('#used_idxs').val().indexOf('are'));
       if( $('#used_idxs').val().indexOf(' ' + value + ' ') > -1 ){
         $('#idx').css({'backgroundColor':'red'});
       } else {
         $('#idx').css({'backgroundColor': 'white'});
       }
     });



});  // document ready function end

function uploadImage(e) {
  cloudinary.openUploadWidget({ cloud_name: 'mnyiaa', upload_preset: 'riceminejp'},
    function(error, result) { console.log(error, result); });
  };

function checkMe(e) {
  this.preventDefault;
  return confirm("Do you want to delete: " + e.toUpperCase() + " permanently?");
};

function confirmMe(e) {
  this.preventDefault;
  return confirm("Are you sure you want to " + e.toUpperCase() + "?");
};
// POPOUT FUNCIONS
//////////////////////
$(document).on('click', '.linkaddress', function(e){
  e.preventDefault();

  var path = this.href;

  $(".popper").load(path + ' .main-profile-container', function () {
    $('header').hide();
    // this keeps track of scroll position before overlay
    scrollPosition = window.pageYOffset;
    const mainEl = document.querySelector('header');
    mainEl.style.top = -scrollPosition + 'px';
    // scroll check end

    $('.main-cont').addClass('hide-main-cont');
    $('.popper').css("visibility", "visible");
    $('.exit-button2').css("visibility", "visible");
    // $('main').css("visibility", "hidden");

    highlightParagraph();
// this code below send google link info/redirect/ajax for analytics
  ga('send', 'pageview', path, {
    dimension1: 'page load'
  });

  });

});

// highlight function
//////////////////////
function highlightParagraph(){
  $('p').each(function() {
    // checks if a <p> element has img imbedded.
    // if it does, then it skips the HIGHLIGHTING, else it highlights
    var name = $(this).children("img").length == 0;
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
}

////////////////////////
// back to top scroll button
window.onscroll = function() {scrollFunction();};

function scrollFunction() {
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
function mobileHide(size, code) {

  $('.mobile').addClass('show');

    // $('pro-img-container').removeClass('mobile');
  if (size == "small") {

      console.log('small');
        $('.pro-image-small').addClass('show');
        $('.pro-image-small').removeClass('hide');
        $('.pro-image-full').empty();
        $('.pro-image-full').removeClass('show');

        $('.pro-image-full').addClass('hide');
  } else {
    console.log('big');
      $('.pro-image-small').removeClass('show');
      $('.pro-image-small').addClass('hide');
      $('.pro-image-full').removeClass('hide');
      $('.pro-image-full').addClass('show');


      var width = $(window).width();
      var height = $(window).height();
      if (width > 900) {
      // $('.pro-image-full').append( "<embed type='video/webm' src='https://live2d-dcg.github.io/viewerK.html?mN=" + code + "&amp;size=600&amp;mS=1.2&amp;mX=0&amp;mY=0' scrolling='no' width='600' height='900'>" );
      $('.pro-image-full').append( "<embed type='video/webm' src='https://live2d-dcg.github.io/viewerK.html?mN=" + code + "&amp;size=700&amp;mS=1.3&amp;mX=0&amp;mY=0.15' scrolling='no' width='600' height='700'>" );
    } else {
      $('.pro-image-full').append( "<embed type='video/webm' src='https://live2d-dcg.github.io/viewerK.html?mN=" + code + "&amp;size=700&amp;mS=1&amp;mX=0&amp;mY=0.15' scrolling='no' width='600' height='700'>" );
    }
  }
};

function  showUnitsTier(type) {
  $('.main-cont .item').each(function(){
    if($(this).hasClass(type)) {
      if ($(this).hasClass('hide-list')) {
        $(this).removeClass('hide-list');
      }
    } else {
        $(this).addClass('hide-list');
    }
});
};

function  showUnitsClass(type) {
  $('.unit-grid-cols').each(function(){
    if($(this).hasClass(type)) {
      if ($(this).hasClass('hide-list')) {
        $(this).removeClass('hide-list');
      }
    } else {
      $(this).addClass('hide-list');
    }
});
};

// function  showUnitAttribute(type) {
//   $('.unit-grid-cols').each(function(){
//     if($(this).hasClass(type)) {
//       if ($(this).hasClass('hide-list')) {
//         $(this).removeClass('hide-list');
//       }
//     } else {
//       $(this).addClass('hide-list');
//     }
// });
// };

function  showUnitAttribute(type) {
  var types = '';
  var eles = '';
  $('.unit-grid-cols').each(function(){


    if (!$(this).hasClass('hide-list')) {
      types = (types === '') ? $(this).attr("class").split(" ")[1] : types;
      eles = (eles === '') ? $(this).attr("class").split(" ")[2] : eles;

    }
});
  $('.unit-grid-cols').each(function() {
    if (!$(this).hasClass('hide-list')) {

        if ($(this).hasClass(type)) {
          console.log(type);
          $(this).removeClass('hide-list');
      } else {
      $(this).addClass('hide-list');
    }
  } else {
      if ($(this).hasClass(type) && $(this).hasClass(types)) {
        console.log(type);
        $(this).removeClass('hide-list');
        } else {
        $(this).addClass('hide-list');
      }
  }

});
};

function checkUrl(e) {
  e.preventDefault;
   var url = window.location.href;
   if (url.endsWith(e)) {
     return false;
   } else {
     window.location.href = this.location.href;
   }
};

function showSearch() {
  $('#main_search').toggleClass('main-search-on');
  $('.search-bar-bg-off').toggleClass('search-bar-bg-on');
};
