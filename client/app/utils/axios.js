const axios = require('axios');
const qs = require('qs');

export default function configureAxios() {
  // Add a request interceptor
  axios.interceptors.request.use(
    // Do something before request is sent
    config => config,
    // Do something with request error
    error => Promise.reject(error)
    ,
  );

  // Add a response interceptor
  axios.interceptors.response.use(
    // Do something with response data
    response => response,
    (rejection) => {
      if (!rejection.response)
        rejection.response = { data: 'Server Unavailable' };
      else if (rejection.response.data && rejection.response.data.message)
        rejection.response.data = rejection.response.data.message;
      else if (rejection.response.status === 500)
        rejection.response.data = 'Internal Server Error. Please contact support@diverst.com';
      else if (rejection.response.status === 503)
        rejection.response.data = 'Server Unavailable';

      // Do something with response error
      return Promise.reject(rejection);
    },
  );

  // Format nested params correctly
  axios.interceptors.request.use((config) => {
    config.paramsSerializer = params => qs.stringify(params, {
      arrayFormat: 'brackets',
      encode: false
    });

    return config;
  });
}
