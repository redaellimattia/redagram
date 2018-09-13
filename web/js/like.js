$(document).ready(function()
{
    $(document).on("click", ".like-href", function(e) //Onclick sul pulsante di like chiamo la funzione like()
    {
      like(e);
    });
    function like(e)
    {
      var url= "../includes/like.jsp?post="+e.target.id; //Url da chiamare con parametro in get
      console.log(url);
      $.ajax({
        type: "POST",
        url: url,
        success: function(res)
        {
          console.log("passo");
          var str = res.split(",");
          var caso=str[0].trim();
          var idPost=str[1].trim();
          console.log(caso+" "+idPost);
          if(caso=="1")
            {
              console.log(  $("#a-"+(idPost.trim())));
              $("#a-"+(idPost.trim())).removeClass("red-like").addClass('black-like');
              $("#m-"+(idPost.trim())).html((parseInt($("#m-"+(idPost.trim())).html().replace(" Likes",""))-1)+" Likes");
            }
          else
            {
              console.log(  $("#a-"+(idPost.trim())));
              $("#a-"+(idPost.trim())).removeClass("black-like").addClass('red-like');
              $("#m-"+(idPost.trim())).html((parseInt($("#m-"+(idPost.trim())).html().replace(" Likes",""))+1)+" Likes");
            }
          updatingModal(idPost);
        }
        });
    }
});
