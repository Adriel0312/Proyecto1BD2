import { Request } from 'src/app/API/Request.component';

export class RequestCustomers extends Request{

  constructor() { super(); }

  async get(params){
    this.url.pathname ="/customers/all";

    Object.keys(params).forEach(key => this.url.searchParams.append(key, params[key]));

    try{
      var result = await this.requestGet(this.url, {"method": "GET","headers": {"Content-Type": undefined}});
      return result;
    }
    catch(err){
      throw err;
    }
  }
}
