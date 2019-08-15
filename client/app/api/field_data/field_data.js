import API from 'api/base/base';
const axios = require('axios');

const FieldData = new API({ controller: 'field_data' });

Object.assign(FieldData, {
  updateFieldData(payload) {
    return axios.post(`${this.url}/update_field_data`, payload);
  }
});

export default FieldData;
