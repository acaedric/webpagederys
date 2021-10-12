function valida(){
    var nombre,correo,mensaje,expresion;
    nombre=document.getElementById("nombreconsulta").value;
    correo=document.getElementById("correoconsulta").value;
    mensaje=document.getElementById("mensajeconsulta").value;

    expresion = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;

    if(nombre === "" || correo ==="" || tema === "" || mensaje === "" ) {

        alert("Todos los campos son obligatorios")
        return false;
    }
    else if(nombre.length>30){
        alert("El nombre es muy largo");
        return false;
    }
    else if(correo.length>30){
        alert("El correo es muy largo");
        return false;
    }
    else if(!expresion.test(correo)){
        alert("El correo electronico no es válido");
        return false;
    }
    else if(mensaje.length>600){
        alert("El mensaje es muy largo");
        return false;
    }

    else{
        alert("Tu mensaje ha sido enviado. Por favor espere la respuesta del equipo CODE")
    }


}

