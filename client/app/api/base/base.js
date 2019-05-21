import config from "../../app.config";

const axios = require("axios");

axios.defaults.baseURL = config.apiUrl;
axios.defaults.headers.common["Diverst-APIKey"] = config.apiKey;
    
class API {
    constructor(args) {
        this.baseUrl = `${axios.defaults.baseURL}/api/v1/`;
        this.controller = args.controller;
        this.url = this.baseUrl + this.controller;
    }

    all(opts) {
        let url = this.url;
        // append query arguments
        if (opts) {
            url += "?";
            for (const arg in opts) {
                if (url.indexOf("?") !== url.length - 1) {
                    url += "&";
                }
                url += `${arg}=${opts[arg]}`;
            }
        }
        return axios.get(url);
    }

    get(id) {
        return axios.get(`${this.url}/${id}`);
    }

    create(payload) {
        return axios.post(this.url, payload);
    }

    update(payload) {
        return axios.put(this.url, payload);
    }

    destroy(id) {
        return axios.delete(`${this.url}/${id}`);
    }
}

export default API;
