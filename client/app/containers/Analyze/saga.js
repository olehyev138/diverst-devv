import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_GROUP_POPULATION_BEGIN, GET_VIEWS_PER_GROUP_BEGIN, GET_GROWTH_OF_GROUPS_BEGIN,
  GET_INITIATIVES_PER_GROUP_BEGIN, GET_MESSAGES_PER_GROUP_BEGIN, GET_VIEWS_PER_NEWS_LINK_BEGIN,
  GET_VIEWS_PER_FOLDER_BEGIN, GET_VIEWS_PER_RESOURCE_BEGIN, GET_GROWTH_OF_RESOURCES_BEGIN,
} from 'containers/Analyze/constants';

import {
  getGroupPopulationSuccess, getGroupPopulationError,
  getViewsPerGroupSuccess, getViewsPerGroupError,
  getGrowthOfGroupsSuccess, getGrowthOfGroupsError,
  getInitiativesPerGroupSuccess, getInitiativesPerGroupError,
  getMessagesPerGroupSuccess, getMessagesPerGroupError,
  getViewsPerNewsLinkSuccess, getViewsPerNewsLinkError,
  getViewsPerFolderSuccess, getViewsPerFolderError,
  getViewsPerResourceSuccess, getViewsPerResourceError,
  getGrowthOfResourcesSuccess, getGrowthOfResourcesError,
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

export function* getInitiativesPerGroup(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.initiativesPerGroup.bind(api.metrics.groupGraphs), action.payload);

    yield put(getInitiativesPerGroupSuccess(response.data));
  } catch (err) {
    yield put(getInitiativesPerGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load initiatives per group graph', options: { variant: 'warning' } }));
  }
}

export function* getMessagesPerGroup(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.messagesPerGroup.bind(api.metrics.groupGraphs), action.payload);

    yield put(getMessagesPerGroupSuccess(response.data));
  } catch (err) {
    yield put(getMessagesPerGroupError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load messages per group graph', options: { variant: 'warning' } }));
  }
}

export function* getViewsPerNewsLink(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.viewsPerNewsLink.bind(api.metrics.groupGraphs), action.payload);

    yield put(getViewsPerNewsLinkSuccess(response.data));
  } catch (err) {
    yield put(getViewsPerNewsLinkError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load views per news link graph', options: { variant: 'warning' } }));
  }
}

export function* getViewsPerFolder(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.viewsPerFolder.bind(api.metrics.groupGraphs), action.payload);

    yield put(getViewsPerFolderSuccess(response.data));
  } catch (err) {
    yield put(getViewsPerFolderError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load views per folder graph', options: { variant: 'warning' } }));
  }
}

export function* getViewsPerResource(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.viewsPerResource.bind(api.metrics.groupGraphs), action.payload);

    yield put(getViewsPerResourceSuccess(response.data));
  } catch (err) {
    yield put(getViewsPerResourceError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load views per resource graph', options: { variant: 'warning' } }));
  }
}

export function* getGrowthOfResources(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.growthOfResources.bind(api.metrics.groupGraphs), action.payload);

    yield put(getGrowthOfResourcesSuccess(response.data));
  } catch (err) {
    yield put(getGrowthOfResourcesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load growth of resources graph', options: { variant: 'warning' } }));
  }
}

export default function* metricsSaga() {
  yield takeLatest(GET_GROUP_POPULATION_BEGIN, getGroupPopulation);
  yield takeLatest(GET_VIEWS_PER_GROUP_BEGIN, getViewsPerGroup);
  yield takeLatest(GET_GROWTH_OF_GROUPS_BEGIN, getGrowthOfGroups);
  yield takeLatest(GET_INITIATIVES_PER_GROUP_BEGIN, getInitiativesPerGroup);
  yield takeLatest(GET_MESSAGES_PER_GROUP_BEGIN, getMessagesPerGroup);
  yield takeLatest(GET_VIEWS_PER_NEWS_LINK_BEGIN, getViewsPerNewsLink);
  yield takeLatest(GET_VIEWS_PER_FOLDER_BEGIN, getViewsPerFolder);
  yield takeLatest(GET_VIEWS_PER_RESOURCE_BEGIN, getViewsPerResource);
  yield takeLatest(GET_GROWTH_OF_RESOURCES_BEGIN, getGrowthOfResources);
}
