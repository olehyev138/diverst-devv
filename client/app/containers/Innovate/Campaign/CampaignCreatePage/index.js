import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Innovate/Campaign/reducer';
import saga from 'containers/Innovate/Campaign/saga';

import { createCampaignBegin, getCampaignsBegin, campaignsUnmount } from 'containers/Innovate/Campaign/actions';
import {
  selectCampaignTotal, selectIsCommitting
} from 'containers/Innovate/Campaign/selectors';

import CampaignForm from 'components/Innovate/Campaign/CampaignForm';

export function CampaignCreatePage(props) {
  useInjectReducer({ key: 'campaigns', reducer });
  useInjectSaga({ key: 'campaigns', saga });

  const rs = new RouteService(useContext);
  const links = {
    CampaignsIndex: ROUTES.admin.innovate.campaigns.index.path(),
  };

  useEffect(() => () => props.campaignsUnmount(), []);

  return (
    <CampaignForm
      createCampaignBegin={props.createCampaignBegin}
      isCommitting={props.isCommitting}
      links={links}
    />
  );
}

CampaignCreatePage.propTypes = {
  createCampaignBegin: PropTypes.func,
  campaignsUnmount: PropTypes.func,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  createCampaignBegin,
  campaignsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(CampaignCreatePage);
