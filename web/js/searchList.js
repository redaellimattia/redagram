var listaQuery=new Array();
function split( val ) {
  return val.split( / \s*/ );
}
function extractLast( term ) {
  return split( term ).pop();
}

$(document).ready(function()
{
   $('#srch-term').keyup(function(event)
   {
     var txt = $('#srch-term').val();
     console.log(txt);
     $("#srch-term").autocomplete(
     {
         source:function(request, response) {
           $.ajax({
                 url:"../includes/search.jsp?opz=3&search="+txt, //passo al jsp di query sul db il testo
                 method:"POST",
                 success:function(html)
                 {
                   listaQuery = html.trim().split(";"); //array finale con i risultati
                   var listFinal = new Array();
                   listaQuery.forEach(function(o)
                   {
                      if(o.indexOf("@"))
                        listFinal.push(o);
                      else if(o.indexOf("#"))
                        listFinal.push(o);
                   });
                   listFinal.splice(-1,1)
                   response(listFinal);
                 }
             });
         },
         focus: function() {
          return false;
        },
        select: function( event, ui ) {
          var terms = split( this.value );
          terms.pop();
          terms.push( ui.item.value );
          terms.push( "" );
          this.value = terms.join( " " );
          return false;
        }
     });
    });
});
