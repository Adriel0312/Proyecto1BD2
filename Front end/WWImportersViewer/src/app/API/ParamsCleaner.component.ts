export class ParamsCleaner {

  constructor() {
    }

  clean(params){

    Object.keys(params).forEach(
      key => {if(!params[key]){delete params[key]}}
    )
    return params;
  }
}
