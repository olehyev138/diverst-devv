import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_GROUP_OVERVIEW_METRICS_BEGIN, GET_GROUP_SPECIFIC_METRICS_BEGIN,
  GET_GROUP_POPULATION_BEGIN, GET_VIEWS_PER_GROUP_BEGIN, GET_GROWTH_OF_GROUPS_BEGIN,
  GET_INITIATIVES_PER_GROUP_BEGIN, GET_NEWS_PER_GROUP_BEGIN, GET_VIEWS_PER_NEWS_LINK_BEGIN,
  GET_VIEWS_PER_FOLDER_BEGIN, GET_VIEWS_PER_RESOURCE_BEGIN, GET_GROWTH_OF_RESOURCES_BEGIN,
  GET_GROWTH_OF_USERS_BEGIN
} from 'containers/Analyze/constants';

import {
  getGroupOverviewMetricsSuccess, getGroupOverviewMetricsError,
  getGroupSpecificMetricsSuccess, getGroupSpecificMetricsError,
  getGroupPopulationSuccess, getGroupPopulationError,
  getViewsPerGroupSuccess, getViewsPerGroupError,
  getGrowthOfGroupsSuccess, getGrowthOfGroupsError,
  getInitiativesPerGroupSuccess, getInitiativesPerGroupError,
  getNewsPerGroupSuccess, getNewsPerGroupError,
  getViewsPerNewsLinkSuccess, getViewsPerNewsLinkError,
  getViewsPerFolderSuccess, getViewsPerFolderError,
  getViewsPerResourceSuccess, getViewsPerResourceError,
  getGrowthOfResourcesSuccess, getGrowthOfResourcesError,
  getGrowthOfUsersSuccess, getGrowthOfUsersError
} from 'containers/Analyze/actions';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

export function* getGroupOverviewMetrics(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.groupOverviewMetrics.bind(api.metrics.groupGraphs), action.payload);

    yield put(getGroupOverviewMetricsSuccess(response.data));
  } catch (err) {
    yield put(getGroupOverviewMetricsError(err));

    yield put(showSnackbar({ message: messages.snackbars.group_overview, options: { variant: 'warning' } }));
  }
}

export function* getGroupSpecificMetrics(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.groupSpecificMetrics.bind(api.metrics.groupGraphs), action.payload);

    yield put(getGroupSpecificMetricsSuccess(response.data));
  } catch (err) {
    yield put(getGroupSpecificMetricsError(err));

    yield put(showSnackbar({ message: messages.snackbars.group_overview, options: { variant: 'warning' } }));
  }
}

export function* getGroupPopulation(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.groupPopulation.bind(api.metrics.groupGraphs), action.payload);

    yield put(getGroupPopulationSuccess(response.data));
  } catch (err) {
    yield put(getGroupPopulationError(err));

    yield put(showSnackbar({ message: messages.snackbars.population, options: { variant: 'warning' } }));
  }
}

export function* getViewsPerGroup(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.viewsPerGroup.bind(api.metrics.groupGraphs), action.payload);

    yield put(getViewsPerGroupSuccess(response.data));
  } catch (err) {
    yield put(getViewsPerGroupError(err));

    yield put(showSnackbar({ message: messages.snackbars.views.group, options: { variant: 'warning' } }));
  }
}

export function* getInitiativesPerGroup(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.initiativesPerGroup.bind(api.metrics.groupGraphs), action.payload);

    yield put(getInitiativesPerGroupSuccess(response.data));
  } catch (err) {
    yield put(getInitiativesPerGroupError(err));

    yield put(showSnackbar({ message: messages.snackbars.group.initiatives, options: { variant: 'warning' } }));
  }
}

export function* getNewsPerGroup(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.newsPerGroup.bind(api.metrics.groupGraphs), action.payload);

    yield put(getNewsPerGroupSuccess(response.data));
  } catch (err) {
    yield put(getNewsPerGroupError(err));

    yield put(showSnackbar({ message: messages.snackbars.group.news, options: { variant: 'warning' } }));
  }
}

export function* getViewsPerNewsLink(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.viewsPerNewsLink.bind(api.metrics.groupGraphs), action.payload);

    yield put(getViewsPerNewsLinkSuccess(response.data));
  } catch (err) {
    yield put(getViewsPerNewsLinkError(err));

    yield put(showSnackbar({ message: messages.snackbars.views.news_link, options: { variant: 'warning' } }));
  }
}

export function* getViewsPerFolder(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.viewsPerFolder.bind(api.metrics.groupGraphs), action.payload);

    yield put(getViewsPerFolderSuccess(response.data));
  } catch (err) {
    yield put(getViewsPerFolderError(err));

    yield put(showSnackbar({ message: messages.snackbars.views.folders, options: { variant: 'warning' } }));
  }
}

export function* getViewsPerResource(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.viewsPerResource.bind(api.metrics.groupGraphs), action.payload);

    yield put(getViewsPerResourceSuccess(response.data));
  } catch (err) {
    yield put(getViewsPerResourceError(err));

    yield put(showSnackbar({ message: messages.snackbars.views.resources, options: { variant: 'warning' } }));
  }
}

export function* getGrowthOfGroups(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.growthOfGroups.bind(api.metrics.groupGraphs), action.payload);

    yield put(getGrowthOfGroupsSuccess(response.data));
  } catch (err) {
    yield put(getGrowthOfGroupsError(err));

    yield put(showSnackbar({ message: messages.snackbars.growth.groups, options: { variant: 'warning' } }));
  }
}

export function* getGrowthOfResources(action) {
  try {
    const response = yield call(api.metrics.groupGraphs.growthOfResources.bind(api.metrics.groupGraphs), action.payload);

    yield put(getGrowthOfResourcesSuccess(response.data));
  } catch (err) {
    yield put(getGrowthOfResourcesError(err));

    yield put(showSnackbar({ message: messages.snackbars.growth.resources, options: { variant: 'warning' } }));
  }
}

export function* getGrowthOfUsers(action) {
  try {
    const response = yield call(api.metrics.userGraphs.growthOfUsers.bind(api.metrics.userGraphs), action.payload);

    yield put(getGrowthOfUsersSuccess(response.data));
  } catch (err) {
    yield put(getGrowthOfUsersError(err));

    yield put(showSnackbar({ message: messages.snackbars.growth.users, options: { variant: 'warning' } }));
  }
}


export default function* metricsSaga() {
  yield takeLatest(GET_GROUP_OVERVIEW_METRICS_BEGIN, getGroupOverviewMetrics);
  yield takeLatest(GET_GROUP_SPECIFIC_METRICS_BEGIN, getGroupSpecificMetrics);
  yield takeLatest(GET_GROUP_POPULATION_BEGIN, getGroupPopulation);
  yield takeLatest(GET_VIEWS_PER_GROUP_BEGIN, getViewsPerGroup);
  yield takeLatest(GET_GROWTH_OF_GROUPS_BEGIN, getGrowthOfGroups);
  yield takeLatest(GET_INITIATIVES_PER_GROUP_BEGIN, getInitiativesPerGroup);
  yield takeLatest(GET_NEWS_PER_GROUP_BEGIN, getNewsPerGroup);
  yield takeLatest(GET_VIEWS_PER_NEWS_LINK_BEGIN, getViewsPerNewsLink);
  yield takeLatest(GET_VIEWS_PER_FOLDER_BEGIN, getViewsPerFolder);
  yield takeLatest(GET_VIEWS_PER_RESOURCE_BEGIN, getViewsPerResource);
  yield takeLatest(GET_GROWTH_OF_RESOURCES_BEGIN, getGrowthOfResources);
  yield takeLatest(GET_GROWTH_OF_RESOURCES_BEGIN, getGrowthOfResources);
  yield takeLatest(GET_GROWTH_OF_USERS_BEGIN, getGrowthOfUsers);
}
