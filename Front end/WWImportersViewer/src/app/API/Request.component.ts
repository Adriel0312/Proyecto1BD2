export class Request {
  url: URL;

  constructor(){
    this.url = new URL("http://localhost:3000");
  }
  /*
  Entradas: url del API que se va a consultar
  Retorno: la respuesta json de la consulta al API
  Descripcion:
  se utiliza async y await para esperar la respuesta antes de continuar
  fetch hace la consulta GET al API y se convierte la respuesta a json
  */
  async requestGet(url,properties){
    console.log(this.url);
    const response = await fetch(url,properties);
    if(response.ok){
      return response.json();
    }
  	else{
      throw new Error("Satus "+response.status+" "+response.statusText);
    }
  }
}
