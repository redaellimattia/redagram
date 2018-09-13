var listaQuery;
var inserito = new Array();
var opz = 0;
function query(txt)
{
    var buff = txt.split(" ");
    buff.forEach(function(o)
    {
      if(o.indexOf("@")==0)
      {
        inserito.push(o.replace("@","")+";"); //elimino la @ e aggiungo ; come separatore
        opz = 1;
      }
      else if (o.indexOf("#")==0)
      {
        inserito.push(o.replace("#","")+";"); //elimino l'# e aggiungo ; come separatore
        opz = 2;
      }

    });
}
function split( val ) {
  return val.split( / \s*/ );
}
function extractLast( term ) {
  return split( term ).pop();
}

$(document).ready(function()
{
   $('#textAreaDesc').keyup(function(event)
   {
     query(event.target.value)
     $("#textAreaDesc").autocomplete(
     {
         source:function(request, response) {
           $.ajax({
                 url:"../includes/search.jsp?opz="+opz+"&search="+inserito[inserito.length-1], //passo al jsp di query sul db il vettore con ogni stringa preceduta da @
                 method:"POST",
                 success:function(html)
                 {
                   listaQuery = html.trim().split(";"); //array finale con i risultati
                   var listFinal = new Array();
                   listaQuery.forEach(function(o)
                   {
                      if(opz == 1)
                        listFinal.push("@"+o); //elimino la @ e aggiungo ; come separatore
                      else
                        listFinal.push("#"+o); //elimino la @ e aggiungo ; come separatore
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
