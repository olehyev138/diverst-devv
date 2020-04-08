import { takeLatest } from 'redux-saga/effects';

import { CREATE_SPONSOR_BEGIN, GET_SPONSORS_BEGIN, GET_SPONSOR_BEGIN, UPDATE_SPONSOR_BEGIN, DELETE_SPONSOR_BEGIN } from 'containers/Shared/Sponsors/constants'

import {
  getSponsors, getSponsor, createSponsors, deleteSponsors, updateSponsor
} from 'containers/Shared/Sponsors/saga';


export default function* sponsorsSaga() {
  yield takeLatest(CREATE_SPONSOR_BEGIN, action => createSponsors(action, 'enterprise_id'));
  yield takeLatest(GET_SPONSORS_BEGIN, getSponsors);
  yield takeLatest(GET_SPONSOR_BEGIN, getSponsor);
  yield takeLatest(UPDATE_SPONSOR_BEGIN, updateSponsor);
  yield takeLatest(DELETE_SPONSOR_BEGIN, deleteSponsors);
}
