import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import {
  GET_ARCHIVES_BEGIN,
  GET_ARCHIVES_SUCCESS,
  GET_ARCHIVES_ERROR
} from "./constants";

import {
  getArchivesBegin,
  getArchivesSuccess,
  getArchivesError
} from "./actions";

export function* getArchives(action){
  try{
    const payload = { resource: action.payload };
    //const response = yield call(api);
  } catch (err) {

  }
}
