import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
import download from 'downloadjs';
const axios = require('axios');

const Users = new API({ controller: 'users' });

Object.assign(Users, {
  findEnterprise(payload) {
    return axios.post(`${this.url}/email`, payload);
  },
  getInvitedUser(payload) {
    return axios.post(`${this.url}/sign_up_token`, payload);
  },
  getOnboardingGroups(payload) {
    return axios.post(`${this.url}/sign_up_groups`, payload);
  },
  signUpUser(payload) {
    return axios.post(`${this.url}/sign_up`, payload);
  },
  requestPasswordReset(payload) {
    return axios.post(`${this.url}/reset_password_request`, payload);
  },
  getPasswordToken(payload) {
    return axios.post(`${this.url}/reset_password_token`, payload);
  },
  passwordReset(payload) {
    return axios.post(`${this.url}/password_reset`, payload);
  },
  prototype(payload) {
    return axios.get(appendQueryArgs(`${this.url}/prototype`, payload));
  },
  budgetApprovers(payload) {
    return axios.get(appendQueryArgs(`${this.url}/budget_approvers`, payload));
  },
  sampleCSV(payload) {
    return axios.get(appendQueryArgs(`${this.url}/sample_csv`, payload)).then(
      response => download(response.data, 'diverst_import.csv', response.content_type)
    );
  },
});

export default Users;
