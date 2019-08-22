import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_GROUP_POPULATION_BEGIN
} from 'containers/Analyze/constants';

import {
  getGroupPopulationSuccess, getGroupPopulationError
} from 'containers/Analyze/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getGroupPopulation(action) {
  try {
    const response = yield call(api.groups.all.bind(api.groups), action.payload);

    yield put(getGroupPopulationSuccess(response.data));
  } catch (err) {
    yield put(getGroupPopulationError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load group population graph', options: { variant: 'warning' } }));
  }
}

export default function* metricsSaga() {
  yield takeLatest(GET_GROUP_POPULATION_BEGIN, getGroupPopulation);
}
