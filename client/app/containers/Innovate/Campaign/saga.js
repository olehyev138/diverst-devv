import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_CAMPAIGNS_BEGIN, CREATE_CAMPAIGN_BEGIN,
  DELETE_CAMPAIGN_BEGIN
} from 'containers/Innovate/Campaign/constants';

import {
  getCampaignsSuccess, getCampaignsError, deleteCampaignSuccess,
  createCampaignError, deleteCampaignError, createCampaignSuccess
} from 'containers/Innovate/Campaign/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getCampaigns(action) {
  try {
    const response = yield call(api.campaigns.all.bind(api.campaigns), action.payload);

    yield put(getCampaignsSuccess(response.data.page));
  } catch (err) {
    yield put(getCampaignsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load campaigns', options: { variant: 'warning' } }));
  }
}

export function* createCampaigns(action) {
  try {
    const payload = { campaign: action.payload };
    const response = yield call(api.campaigns.create.bind(api.campaigns), payload);

    yield put(createCampaignSuccess());
    yield put(push(ROUTES.group.campaigns.index.path(action.payload.groupId)));
    yield put(showSnackbar({ message: 'Campaign created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createCampaignError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create campaigns', options: { variant: 'warning' } }));
  }
}

export function* deleteCampaigns(action) {
  try {
    const payload = {
      campaign_ids: [action.payload.userId]
    };

    yield call(api.campaigns.destroy.bind(api.campaigns), payload);

    yield put(deleteCampaignSuccess());
    yield put(push(ROUTES.group.campaigns.index.path(action.payload.groupId)));
    yield put(showSnackbar({ message: 'User deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteCampaignError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to remove campaigns', options: { variant: 'warning' } }));
  }
}

export default function* campaignsSaga() {
  yield takeLatest(GET_CAMPAIGNS_BEGIN, getCampaigns);
  yield takeLatest(CREATE_CAMPAIGN_BEGIN, createCampaigns);
  yield takeLatest(DELETE_CAMPAIGN_BEGIN, deleteCampaigns);
}
