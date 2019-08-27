import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_GROUP_POPULATION_BEGIN, GET_VIEWS_PER_GROUP_BEGIN, GET_GROWTH_OF_GROUPS_BEGIN
} from 'containers/Analyze/constants';

import {
  getGroupPopulationSuccess, getGroupPopulationError,
  getViewsPerGroupSuccess, getViewsPerGroupError,
  getGrowthOfGroupsSuccess, getGrowthOfGroupsError
} from 'containers/Analyze/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getGroupPopulation(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.groupPopulation.bind(api.metrics.groupGraphs), action.payload);

    yield put(getGroupPopulationSuccess(response.data));
  } catch (err) {
    yield put(getGroupPopulationError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load group population graph', options: { variant: 'warning' } }));
  }
}

export function* getViewsPerGroup(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.viewsPerGroup.bind(api.metrics.groupGraphs), action.payload);

    yield put(getViewsPerGroupSuccess(response.data));
  } catch (err) {
    yield put(getViewsPerGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load views per group graph', options: { variant: 'warning' } }));
  }
}

export function* getGrowthOfGroups(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.growthOfGroups.bind(api.metrics.groupGraphs), action.payload);

    yield put(getGrowthOfGroupsSuccess(response.data));
  } catch (err) {
    yield put(getGrowthOfGroupsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load growth of groups graph', options: { variant: 'warning' } }));
  }
}

export default function* metricsSaga() {
  yield takeLatest(GET_GROUP_POPULATION_BEGIN, getGroupPopulation);
  yield takeLatest(GET_VIEWS_PER_GROUP_BEGIN, getViewsPerGroup);
  yield takeLatest(GET_GROWTH_OF_GROUPS_BEGIN, getGrowthOfGroups);
}
