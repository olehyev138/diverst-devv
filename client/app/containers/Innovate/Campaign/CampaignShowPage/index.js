import React, { memo, useEffect, useState } from 'react';
import CampaignQuestionListPage from 'containers/Innovate/Campaign/CampaignQuestion/CampaignQuestionListPage';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Innovate/Campaign/reducer';
import saga from 'containers/Innovate/Campaign/saga';

import { getCampaignBegin, campaignsUnmount } from 'containers/Innovate/Campaign/actions';
import {
  selectCampaign,
  selectIsFormLoading
} from 'containers/Innovate/Campaign/selectors';

import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function CampaignShowPage(props) {
  useInjectReducer({ key: 'campaigns', reducer });
  useInjectSaga({ key: 'campaigns', saga });

  const { campaign_id: campaignId } = useParams();

  const [params, setParams] = useState({
    count: 10, page: 0, orderBy: '', order: 'asc'
  });

  const links = {
    CampaignsIndex: ROUTES.admin.innovate.campaigns.index.path(),
  };

  useEffect(() => {
    props.getCampaignBegin({ id: campaignId });

    return () => props.campaignsUnmount();
  }, []);
  return (
    <React.Fragment>
      <CampaignQuestionListPage {...props} />
    </React.Fragment>
  );
}

CampaignShowPage.propTypes = {
  getCampaignBegin: PropTypes.func,
  campaignsUnmount: PropTypes.func,
  isFormLoading: PropTypes.bool,
  campaign: PropTypes.object,
  users: PropTypes.array,
};

const mapStateToProps = createStructuredSelector({
  campaign: selectCampaign(),
  isFormLoading: selectIsFormLoading(),
});

const mapDispatchToProps = {
  getCampaignBegin,
  campaignsUnmount,
};
const withConnect = connect(
  mapStateToProps,

  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  CampaignShowPage,
  ['campaign.permissions.show?', 'isFormLoading'],
  (props, params) => ROUTES.admin.innovate.campaigns.index.path(),
  permissionMessages.innovate.campaign.showPage
));
