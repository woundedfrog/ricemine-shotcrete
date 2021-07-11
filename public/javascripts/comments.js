$( document ).ready(function() {
  // $("#comment_box").hide();
});
function showcomments(e) {
  commentBox('5631941701271552-proj');
    // $("#comment_box").toggle();
    $("#comment_box").toggleClass('hide_commentbox');
    $("#comment_box").toggleClass('show_commentbox');
};

//Layout tags <script src="https://unpkg.com/commentbox.io/dist/commentBox.min.js"></script>
//Layout tags  <script type="text/javascript" src="/javascripts/comments.js?v=0.1"></script>


<div  class="sub-stat-div">
  <button id="comment_button" type="button" name="button" onClick="showcomments()" >Comments</button>
</div>
<div id="comment_box" class="commentbox hide_commentbox"></div>
</div>

</div>
