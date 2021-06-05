$( document ).ready(function() {
  // $("#comment_box").hide();
});
function showcomments(e) {
  commentBox('5631941701271552-proj');
    // $("#comment_box").toggle();
    $("#comment_box").toggleClass('hide_commentbox');
    $("#comment_box").toggleClass('show_commentbox');
};
